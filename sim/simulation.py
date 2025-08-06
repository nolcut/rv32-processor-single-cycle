import subprocess
import threading
import sys
from time import sleep
from constants import PROCESSOR_PATH


class Simulation:
    """Starts simulation subprocess and handles termination"""

    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def __init__(self):
        if not hasattr(self, "_initialized"): 
            self.simulation = None
            self.compiled = False
            self._initialized = True

    def start(self):
        """
        Start simulation

        Returns:
            subprocess -- simulation process
        """
        if self.simulation:
            print("Error: Cannot start another simulation while one is already running")
            sys.exit(1)

        if not self.compiled:
            self.compile()

        # run sim
        run_cmd = ["vvp", "castor32rv_test"]

        self.simulation = subprocess.Popen(
            run_cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            stdin=subprocess.DEVNULL,
            text=True,
        )

        sleep(1)

        # reads stdout of simulation
        thread = threading.Thread(
            target=Simulation.display_out, args=(self.simulation.stdout,), daemon=True
        )
        thread.start()

    def compile(self):
        """Compile the simulation"""
        # find sv files
        sv_files = [str(p) for p in PROCESSOR_PATH.rglob("*.sv")]

        # compile
        init_cmd = ["iverilog", "-g2012", "-o", "castor32rv_test"] + sv_files

        subprocess.run(
            init_cmd,
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            stdin=subprocess.DEVNULL,
        )

        self.compiled = True

    def kill(self):
        """Kills simulation if one is running"""
        if self.simulation:
            self.simulation.terminate()

        self.simulation = None

    @staticmethod
    def display_out(output):
        """
        print an io stream

        Arguments:
            output -- stdout to print from
        """
        for line in output:
            if line.startswith("WARNING"):
                continue
            print(line, end="")
