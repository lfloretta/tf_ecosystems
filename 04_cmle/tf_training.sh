#!/bin/bash
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
set -u

echo Starting TF training...

PROJECT=lf-ml-demo
BUCKET=lf-ml-demo-us-c1
BQ_TABLE=bigquery-public-data.chicago_taxi_trips.taxi_trips
REGION=us-central1


# JOB_OUTPUT_PATH="gs://${BUCKET}/taxi-fare/$(date +%Y%m%d)"
JOB_OUTPUT_PATH="gs://${BUCKET}/taxi-fare/20190826"

TFDV_OUTPUT_PATH=$JOB_OUTPUT_PATH/tfdv_train_test_output

TFT_OUTPUT_PATH="$JOB_OUTPUT_PATH/tft_train_test"

JOB_DIR="$JOB_OUTPUT_PATH/cmle-output-$(date +%Y%m%d-%H%M%S)"
# JOB_DIR="./tmp"


JOB_ID="taxi_fare_train_$(date +%Y%m%d_%H%M%S)"
TEMP_PATH="gs://${BUCKET}/$JOB_ID/tmp"

#python3 -m trainer.task --tft-output-dir ${TFT_OUTPUT_PATH} \
#                        --job-dir ${JOB_DIR} \
#                        --embedding-size 8 \
#                        --first-layer-size 40 \
#                        --num-layers 5 \
#                        --scale-factor 0.7 \
#                        --train-steps 500 \
#                        --schema-file ${TFDV_OUTPUT_PATH}/schema.pbtxt

TF_VERSION=1.14

gcloud ai-platform jobs submit training  $JOB_ID \
                                    --job-dir ${JOB_DIR} \
                                    --runtime-version $TF_VERSION \
                                    --python-version 3.5 \
                                    --module-name trainer.task \
                                    --package-path trainer/ \
                                    --region ${REGION} \
                                    --config hyperparameter.yaml \
                                    --project ${PROJECT} \
                                    --packages ../utils/dist/utils-0.1.tar.gz \
                                    -- \
                                    --tft-output-dir ${TFT_OUTPUT_PATH} \
                                    --embedding-size 8 \
                                    --first-layer-size 40 \
                                    --num-layers 5 \
                                    --scale-factor 0.7 \
                                    --train-steps 500 \
                                    --schema-file ${TFDV_OUTPUT_PATH}/schema.pbtxt

