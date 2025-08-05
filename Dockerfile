FROM python:3.13

WORKDIR /rv32-script

RUN pip install riscv-assembler

RUN apt-get update && \
    apt-get install -y iverilog && \
    pip install riscv-assembler && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY SystemVerilog/ ./SystemVerilog/
COPY sim_runner.py simulation.py .

CMD ["python3", "sim_runner.py"]
