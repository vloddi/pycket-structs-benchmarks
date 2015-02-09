import argparse
import os
import subprocess

PYCKET = "pycket"
RACKET = "racket"

parser = argparse.ArgumentParser(description="Micro-benchmarks for Structs in Pycket.")
parser.add_argument("--repeat", default=10)
args = parser.parse_args()

for file in os.listdir("./micro-benchmarks"):
    if file.endswith(".rkt"):
        print "Runnung", file, ".."
        pycket_time, pycket_memory = 0.0, 0.0
        racket_time, racket_memory = 0.0, 0.0
        for i in xrange(args.repeat):
            # Pycket
            pycket_result = subprocess.check_output(["/usr/bin/time", "-lp", PYCKET, "./micro-benchmarks/" + str(file)], stderr=subprocess.STDOUT)
            pycket_time += int(pycket_result.split(" real time:")[0][10:])
            pycket_memory += int(pycket_result.split("  maximum resident set size")[0].split("\n")[-1])

            # Racket
            racket_result = subprocess.check_output(["/usr/bin/time", "-lp", RACKET, "./micro-benchmarks/" + str(file)], stderr=subprocess.STDOUT)
            racket_time += int(racket_result.split(" real time:")[0][10:])
            racket_memory += int(racket_result.split("  maximum resident set size")[0].split("\n")[-1])

        pycket_time /= float(args.repeat)
        pycket_memory /= float(args.repeat)
        racket_time /= float(args.repeat)
        racket_memory /= float(args.repeat)

        print "Execution time: racket:", racket_time, "pycket:", pycket_time
        print "Memory consumption: racket:", racket_memory / 1024.0 / 1024.0, "(MB) pycket:", pycket_memory / 1024.0 / 1024.0, "(MB)"
        print
