#!/bin/bash -e
# used pip packages


pip_packages="nose numpy opencv-python mxnet"
target_dir=./dali/test/python

one_config_only=true

do_once() {
    NUM_GPUS=$(nvidia-smi -L | wc -l)
}

test_body() {
    for fw in "mxnet"; do
        python test_RN50_data_fw_iterators.py --framework ${fw} --gpus ${NUM_GPUS} -b 13 \
            --workers 3 --prefetch 2 -i 100 --epochs 2
        python test_RN50_data_fw_iterators.py --framework ${fw} --gpus ${NUM_GPUS} -b 13 \
            --workers 3 --prefetch 2 -i 2 --epochs 2 --fp16
    done
    nosetests --verbose -m '(?:^|[\b_\./-])[Tt]est.*mxnet*' test_fw_iterators_detection.py
    nosetests --verbose -m '(?:^|[\b_\./-])[Tt]est.*mxnet*' test_fw_iterators.py
    nosetests --verbose -m '(?:^|[\b_\./-])[Tt]est.*gluon*' test_fw_iterators.py
}

pushd ../..
source ./qa/test_template.sh
popd
