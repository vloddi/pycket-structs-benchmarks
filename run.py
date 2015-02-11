import argparse
import math
import os
import statistics
import subprocess

interpreters = ('racket',
    'pycket')

z_score = 1.96 # for 95% confidence level

def update_progress(progress, benchmark = ''):
    width = int(os.popen('stty size', 'r').read().split()[1]) - 11 - len(benchmark)
    benchmark_name = ' (' + benchmark + ')' if len(benchmark) > 0 else ''
    print(('\r[{0:' + str(width) + 's}] {1:.1f}%').format('#' * int(progress * width),
        progress * 100) + benchmark_name, end='', flush=True)

def main():
    parser = argparse.ArgumentParser(description='Micro-benchmarks for Structs in Pycket.')
    parser.add_argument('--repeat', default=5)
    parser.add_argument('--output', default='execution_time.csv')
    parser.add_argument('--memory_output', default='memor_consumption.csv')
    args = parser.parse_args()

    benchmarks = [f for f in os.listdir('./micro-benchmarks') if f.endswith('.rkt')]
    with open(args.output,'w') as f: f.write(';' + ';±;'.join(interpreters) + ';±\n')
    with open(args.memory_output,'w') as f: f.write(';' + ';±;'.join(interpreters) + ';±\n')

    for (i, benchmark) in enumerate(benchmarks):
        with open(args.output,'ab') as f: f.write(bytes(benchmark, 'UTF-8'))
        with open(args.memory_output,'ab') as f: f.write(bytes(benchmark, 'UTF-8'))
        for (j, interpreter) in enumerate(interpreters):
            update_progress(float(10*i + j) / float(len(benchmarks * 10) + len(interpreters)), benchmark)
            time, memory = [], []
            for _ in range(int(args.repeat)):
                result = str(subprocess.check_output(['/usr/bin/time', '-lp', interpreter,\
                    './micro-benchmarks/' + str(benchmark)], stderr=subprocess.STDOUT), encoding='utf8')
                try:
                    current_time = int(result.split(' real time:')[0].split(' ')[-1])
                    time.append(current_time)
                    current_memory = int(result.split('  maximum resident set size')[0].split('\n')[-1])
                    memory.append(current_memory)
                except Exception:
                    print('ERROR: Failed to parse result:', result)
                    continue
            time_avg = statistics.mean(time)
            time_sd = statistics.stdev(time)
            time_errors = z_score * time_sd / math.sqrt(int(args.repeat))
            memory_avg = statistics.mean(memory)
            memory_sd = statistics.stdev(memory)
            memory_errors = z_score * memory_sd / math.sqrt(int(args.repeat))
            with open(args.output,'ab') as f: f.write(bytes(';' + str(time_avg) + ';' + str(round(time_errors)), 'UTF-8'))
            with open(args.memory_output,'ab') as f:
                # 1048576 = 1024 * 1024
                f.write(bytes(';' + str(memory_avg / 1048576.0) + ';' + str(round(memory_errors / 1048576.0, 2)), 'UTF-8'))
        with open(args.output,'ab') as f: f.write(bytes('\n', 'UTF-8'))
        with open(args.memory_output,'ab') as f: f.write(bytes('\n', 'UTF-8'))
    update_progress(1)

if __name__ == '__main__':
    main()
