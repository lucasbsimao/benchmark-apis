import matplotlib.pyplot as plt
import csv

timestamps = []
cpu_usage = []
ram_usage = []

with open('output.csv', 'r') as file:
    csv_reader = csv.reader(file)
    for row in csv_reader:
        timestamps.append(int(row[0])) 
        cpu_usage.append(float(row[1]))
        ram_usage.append(float(row[2]))

plt.figure(figsize=(12, 6))

plt.subplot(2, 1, 1)
plt.plot(timestamps, cpu_usage, label='CPU Usage')
plt.title('CPU Usage Over Time')
plt.xlabel('Time in seconds')
plt.ylabel('CPU Usage (%)')
plt.legend()

plt.subplot(2, 1, 2)
plt.plot(timestamps, ram_usage, label='RAM Usage')
plt.title('RAM Usage Over Time')
plt.xlabel('Time in seconds')
plt.ylabel('RAM Usage (%)')
plt.legend()


plt.tight_layout()

plt.savefig('cpu_ram_plots.png')
