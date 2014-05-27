#_*_coding:utf-8_*_

import sys
import re

def read_tcpfile(path):
	ret = []
	with open(path, "r") as f:
		for line in f.readlines():
			line = re.sub(r'\s+', ",", line)
			ret.append(line.split(","))
	return ret

def write_plotfile(path, lines):
	for i in range(len(lines)):
		lines[i] = " ".join(lines[i]) + "\n"

	with open(path, "w") as f:
		f.writelines(lines)

def filter_data(node_index, lines):
	ret = []
	for line in lines:
		print line
		if line[1] == node_index and line[-3] == "cwnd_":
			ret.append(line)
	return ret

def main():
	argvs = sys.argv
	if len(argvs) != 4:
		print "Input node index"
		return
	target = argvs[1]
	output = argvs[2]
	node_index = argvs[3]

	lines = read_tcpfile(target)
	filtered = filter_data(node_index, lines)
	write_plotfile(output, filtered)

if __name__ == "__main__":
	main()
