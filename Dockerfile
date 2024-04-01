FROM nvidia/cuda:12.1.0-devel-ubuntu22.04

RUN apt-get update -y \
    && apt-get install -y python3-pip git

WORKDIR /workspace

COPY requirements.txt requirements.txt

COPY vllm vllm 

COPY cmake cmake

COPY csrc csrc

COPY CMakeLists.txt CMakeLists.txt

COPY setup.py setup.py

COPY collect_env.py collect_env.py

RUN pip install -r requirements.txt

RUN pip install .

RUN python3 setup.py develop

ENV CUDA_VISIBLE_DEVICES 3

ENTRYPOINT ["python3", "-m", "vllm.entrypoints.openai.api_server", "--model", "/model/llava", "--port", "8000"]
