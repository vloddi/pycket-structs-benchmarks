import argparse
import math
import os
# import scipy.stats as st
import statistics
import subprocess

PYCKET = "pycket"
RACKET = "racket"

parser = argparse.ArgumentParser(description="Micro-benchmarks for Structs in Pycket.")
# parser.add_argument("--confidence", default=0.95)
parser.add_argument("--repeat", default=5)
args = parser.parse_args()

z_score = 1.96
# z_score = st.norm.ppf(float(args.confidence))

for file in os.listdir("./micro-benchmarks"):
    if file.endswith(".rkt"):
        print("Runnung", file, "..")
        for interpreter in (PYCKET, RACKET):
            time, memory = [], []
            for i in range(int(args.repeat)):
                result = subprocess.check_output(["/usr/bin/time", "-lp", interpreter, "./micro-benchmarks/" + str(file)], stderr=subprocess.STDOUT)
                result = str(result, encoding="utf8")
                time.append(int(result.split(" real time:")[0][10:]))
                memory.append(int(result.split("  maximum resident set size")[0].split("\n")[-1]))
            time_avg = statistics.mean(time)
            time_sd = statistics.stdev(time)
            time_errors = z_score * time_sd / math.sqrt(int(args.repeat))
            memory_avg = statistics.mean(memory)
            memory_sd = statistics.stdev(memory)
            memory_errors = z_score * memory_sd / math.sqrt(int(args.repeat))
            print(interpreter)
            print("Execution time:", time_avg, "±", round(time_errors),\
                "\nMemory consumption:", memory_avg / 1048576.0, "±", round(memory_errors / 1048576.0), "\n")
