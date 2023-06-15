import os
import subprocess
import matplotlib.pyplot as plt


def sequenceGenerator(iterations):

    templateSequence = "ATGCG"

    templateSequenceList = []
    for i in range(iterations):
        if i == 0:
            templateSequenceList.append(templateSequence)
        else:
            templateSequenceList.append("{seq}ATGCG".format(seq=templateSequenceList[i-1]))

    return templateSequenceList

def compileProgramm():
    os.system("gapc -i global alignment.gap --tab A --tab D")
    os.system("make -f out.mf")

def calculateRuntime(templates : list):

    calculationList = []

    for template in templates:

        command = "/usr/bin/time -v ./out '{seq1}' '{seq2}' 2>&1 | grep -e 'User'".format(seq1=template, seq2=template)
        command2 = "/usr/bin/time -v ./out '{seq1}' '{seq2}' 2>&1 | grep -e 'Maximum resident set size'".format(seq1=template, seq2=template)
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        result2 = subprocess.run(command2, shell=True, capture_output=True, text=True)
        calculationList.append((result.stdout.split(":")[-1].split("\n")[0], result2.stdout.split(":")[-1].split("\n")[0], len(template)))


    return calculationList

def graph(calcs):

    x = [number[2] for number in calcs]
    y_ram = [number[1] for number in calcs]
    y_time = [number[0] for number in calcs]

    plt.scatter(x, y_time)
    plt.plot(x, y_time, 'b-')
    plt.ylabel("User Time")
    plt.xlabel("Sequence Length")
    plt.savefig("/home/daniel/JLUbox/Master_Bioinfo/Semester_2/M-BS2-S5B/Workspace/tables/graphics/USER_TIME_AD")
    plt.close()

    plt.scatter(x, y_ram)
    plt.plot(x, y_ram, 'b-')
    plt.ylabel("RAM")
    plt.xlabel("Sequence Length")
    plt.savefig("/home/daniel/JLUbox/Master_Bioinfo/Semester_2/M-BS2-S5B/Workspace/tables/graphics/RAM_AD")
    plt.close()






# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    templates = sequenceGenerator(100)
    #compileProgramm()
    calcs = calculateRuntime(templates=templates)
    graph(calcs=calcs)



# See PyCharm help at https://www.jetbrains.com/help/pycharm/
