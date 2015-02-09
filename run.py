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
        pycket_time, pycket_memory, racket_time, racket_memory = [], [], [], []
        for i in range(int(args.repeat)):
            # Pycket
            pycket_result = subprocess.check_output(["/usr/bin/time", "-lp", PYCKET, "./micro-benchmarks/" + str(file)], stderr=subprocess.STDOUT)
            pycket_result = str(pycket_result, encoding='utf8')
            pycket_time.append(int(pycket_result.split(" real time:")[0][10:]))
            pycket_memory.append(int(pycket_result.split("  maximum resident set size")[0].split("\n")[-1]))

            # Racket
            racket_result = subprocess.check_output(["/usr/bin/time", "-lp", RACKET, "./micro-benchmarks/" + str(file)], stderr=subprocess.STDOUT)
            racket_result = str(racket_result, encoding='utf8')
            racket_time.append(int(racket_result.split(" real time:")[0][10:]))
            racket_memory.append(int(racket_result.split("  maximum resident set size")[0].split("\n")[-1]))

        # Results
        pycket_time_avg = statistics.mean(pycket_time)
        pycket_time_sd = statistics.stdev(pycket_time)
        pycket_errors = z_score * pycket_time_sd / math.sqrt(int(args.repeat))

        racket_time_avg = statistics.mean(racket_time)
        racket_time_sd = statistics.stdev(racket_time)
        racket_errors = z_score * racket_time_sd / math.sqrt(int(args.repeat))

        pycket_memory_avg = statistics.mean(pycket_memory)
        pycket_memory_sd = statistics.stdev(pycket_memory)
        pycket_memory_errors = z_score * pycket_memory_sd / math.sqrt(int(args.repeat))

        racket_memory_avg = statistics.mean(racket_memory)
        racket_memory_sd = statistics.stdev(racket_memory)
        racket_memory_errors = z_score * racket_memory_sd / math.sqrt(int(args.repeat))

        print("Execution time: racket:", racket_time_avg, "±", round(racket_errors, 2),\
            "pycket:", pycket_time_avg, "±", round(pycket_errors, 2), \
            "\nMemory consumption: racket:", racket_memory_avg / 1048576.0, "±", round(racket_memory_errors / 1048576.0, 2),\
            "pycket:", pycket_memory_avg / 1048576.0, "±", round(pycket_memory_errors / 1048576.0, 2))
