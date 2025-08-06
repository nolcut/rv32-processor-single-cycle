FROM python:3.13

WORKDIR /sim

RUN pip install riscv-assembler

RUN apt-get update && \
    apt-get install -y iverilog && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install git+https://github.com/nolcut/riscv-assembler.git

COPY SystemVerilog/ ../SystemVerilog/
RUN ls -R ../SystemVerilog/
COPY sim/ ./

CMD ["python3", "sim_runner.py"]
