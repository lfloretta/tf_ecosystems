import setuptools

setuptools.setup(
    name='tfdv_train_test',
    version='0.1',
    install_requires=['apache_beam[gcp]==2.11.0',
                      'tensorflow==2.4.0rc4',
                      'tensorflow-model-analysis==0.13.0',
                      'tensorflow-transform==0.13.0'],
    packages=setuptools.find_packages(),
)