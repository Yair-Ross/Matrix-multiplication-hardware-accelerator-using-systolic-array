import numpy as np
from scanf import scanf


matfile_fd = open("C:\\verilog_files\\tb_txt_files\\mat_inputs.txt", 'r')
f = open("C:\\verilog_files\\tb_txt_files\\golden_outputs.txt", 'w')

for n in range(30):
    # Read the line from the file
    line = matfile_fd.readline()

    # Scan the line using the specified format
    result = scanf("%1d%1d%1d%1d%1d%1d\n", line)

    # Check if all 6 variables were successfully scanned
    if len(result) == 6:
        calc_mod, dest, c, n, k, m = result
        # Process the variables as needed
        print(f"calc_mod: {calc_mod}, dest: {dest}, c: {c}, n: {n}, k: {k}, m: {m}")
    else:
        # Handle the case where not all variables were successfully scanned
        print("Error: Not all variables could be scanned.")


    # Initialize the matrix
    matrixA = np.array([[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]])
    matrixB = np.array([[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]])

    binary_lines = []
    line = matfile_fd.readline()
    binary_lines.append(scanf("%s\n", line))
    line = matfile_fd.readline()
    binary_lines.append(scanf("%s\n", line))
    line = matfile_fd.readline()
    binary_lines.append(scanf("%s\n", line))
    line = matfile_fd.readline()
    binary_lines.append(scanf("%s\n", line))
    print(binary_lines)
    # Iterate over each line
    for i, line in enumerate(binary_lines):
        # Iterate over each 16-bit chunk and update the corresponding matrix element
        for j in range(4):
            binary_number = line[0][j * 8:(j + 1) * 8]
            # Check if the most significant bit is 1 (indicating a negative number)
            if binary_number[0] == '1':
                # Convert binary_number to a negative signed integer
                matrixA[i][3-j] = -(256 - int(binary_number, 2))
            else:
                # Convert binary_number to a positive signed integer
                matrixA[i][3-j] = int(binary_number, 2)

    # Print the resulting matrix
    for row in matrixA:
        print(row)

    binary_lines = []
    line = matfile_fd.readline()
    binary_lines.append(scanf("%s\n", line))
    line = matfile_fd.readline()
    binary_lines.append(scanf("%s\n", line))
    line = matfile_fd.readline()
    binary_lines.append(scanf("%s\n", line))
    line = matfile_fd.readline()
    binary_lines.append(scanf("%s\n", line))
    print(binary_lines)
    # Iterate over each line
    for i, line in enumerate(binary_lines):
        # Iterate over each 16-bit chunk and update the corresponding matrix element
        for j in range(4):
            binary_number = line[0][j * 8:(j + 1) * 8]
            # Check if the most significant bit is 1 (indicating a negative number)
            #print(str(j) + ',' + str(i))
            if binary_number[0] == '1':
                # Convert binary_number to a negative signed integer
                matrixB[3-j][i] = -(256 - int(binary_number, 2))
            else:
                # Convert binary_number to a positive signed integer
                matrixB[3-j][i] = int(binary_number, 2)

    # Print the resulting matrix
    for row in matrixB:
        print(row)

    mat_c = np.dot(matrixA,matrixB)
    #mat_c = matrixA + matrixB
    for row in mat_c:
        for element in row:
            print(element)


    # Iterate through each element of the matrix
    for row in mat_c:
        for element in row:
             # Convert each element to 32-bit binary format with leading zeros
            binary_str = format(element & 0xFFFFFFFF, '032b')
            # Write the binary string to the file with spaces between every 8 bits
            f.write(binary_str)
            f.write('\n')



    # Read the line from the file
    line = matfile_fd.readline()
    # Scan the line using the specified format
    result = scanf("%1d%1d%1d%1d%1d%1d\n", line)

    # Check if all 6 variables were successfully scanned
    if len(result) == 6:
        calc_mod, dest, c, n, k, m = result
        # Process the variables as needed
        print(f"calc_mod: {calc_mod}, dest: {dest}, c: {c}, n: {n}, k: {k}, m: {m}")
    else:
        # Handle the case where not all variables were successfully scannedscanned
        print("Error: Not all variables could be scanned.")



    binary_lines = []
    line = matfile_fd.readline()
    binary_lines.append(scanf("%s\n", line))
    line = matfile_fd.readline()
    binary_lines.append(scanf("%s\n", line))
    line = matfile_fd.readline()
    binary_lines.append(scanf("%s\n", line))
    line = matfile_fd.readline()
    binary_lines.append(scanf("%s\n", line))
    print(binary_lines)
    # Iterate over each line
    for i, line in enumerate(binary_lines):
        # Iterate over each 16-bit chunk and update the corresponding matrix element
        for j in range(4):
            binary_number = line[0][j * 8:(j + 1) * 8]
            # Check if the most significant bit is 1 (indicating a negative number)
            if binary_number[0] == '1':
                # Convert binary_number to a negative signed integer
                matrixA[i][3-j] = -(256 - int(binary_number, 2))
            else:
                # Convert binary_number to a positive signed integer
                matrixA[i][3-j] = int(binary_number, 2)

    # Print the resulting matrix
    for row in matrixA:
        print(row)

    binary_lines = []
    line = matfile_fd.readline()
    binary_lines.append(scanf("%s\n", line))
    line = matfile_fd.readline()
    binary_lines.append(scanf("%s\n", line))
    line = matfile_fd.readline()
    binary_lines.append(scanf("%s\n", line))
    line = matfile_fd.readline()
    binary_lines.append(scanf("%s\n", line))
    print(binary_lines)
    # Iterate over each line
    for i, line in enumerate(binary_lines):
        # Iterate over each 16-bit chunk and update the corresponding matrix element
        for j in range(4):
            binary_number = line[0][j * 8:(j + 1) * 8]
            # Check if the most significant bit is 1 (indicating a negative number)
            if binary_number[0] == '1':
                # Convert binary_number to a negative signed integer
                matrixB[3-j][i] = -(256 - int(binary_number, 2))
            else:
                # Convert binary_number to a positive signed integer
                matrixB[3-j][i] = int(binary_number, 2)

    # Print the resulting matrix
    for row in matrixB:
        print(row)

    mat_d = np.dot(matrixA,matrixB) + mat_c

    for row in mat_d:
        for element in row:
            print(element)


    for row in mat_d:
        for element in row:
             # Convert each element to 32-bit binary format with leading zeros
            binary_str = format(element & 0xFFFFFFFF, '032b')
            # Write the binary string to the file with spaces between every 8 bits
            f.write(binary_str)
            f.write('\n')









line = matfile_fd.readline()

# Scan the line using the specified format
result = scanf("%1d%1d%1d%1d%1d%1d\n", line)

# Check if all 6 variables were successfully scanned
if len(result) == 6:
    calc_mod, dest, c, n, k, m = result
    # Process the variables as needed
    print(f"calc_mod: {calc_mod}, dest: {dest}, c: {c}, n: {n}, k: {k}, m: {m}")
else:
    # Handle the case where not all variables were successfully scanned
    print("Error: Not all variables could be scanned.")
#matrixA = np.array([[33, 77, 23, 0], [55, 34, 9, 0], [0, 0, 0, 0], [0, 0, 0, 0]])
#matrixB = np.array([[12, 14, 0, 0], [17, 24, 0, 0], [3, 11, 0, 0], [0, 0, 0, 0]])
matrixA = np.array([[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]])
matrixB = np.array([[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]])



binary_lines = []
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
print(binary_lines)
# Iterate over each line
for i, line in enumerate(binary_lines):
    # Iterate over each 16-bit chunk and update the corresponding matrix element
    if(i<2):
        for j in range(4):
            if(j>0):
                binary_number = line[0][j * 8:(j + 1) * 8]
                # Check if the most significant bit is 1 (indicating a negative number)
                if binary_number[0] == '1':
                    # Convert binary_number to a negative signed integer
                    matrixA[i][3-j] = -(256 - int(binary_number, 2))
                else:
                    # Convert binary_number to a positive signed integer
                    matrixA[i][3-j] = int(binary_number, 2)

# Print the resulting matrix
for row in matrixA:
    print(row)

binary_lines = []
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
print(binary_lines)
# Iterate over each line
for i, line in enumerate(binary_lines):
    # Iterate over each 16-bit chunk and update the corresponding matrix element
    if (i < 2):
        for j in range(4):
            if (j > 0):
                binary_number = line[0][j * 8:(j + 1) * 8]
                # Check if the most significant bit is 1 (indicating a negative number)
                #print(str(j) + ',' + str(i))
                if binary_number[0] == '1':
                    # Convert binary_number to a negative signed integer
                    matrixB[3-j][i] = -(256 - int(binary_number, 2))
                else:
                    # Convert binary_number to a positive signed integer
                    matrixB[3-j][i] = int(binary_number, 2)

# Print the resulting matrix
for row in matrixB:
    print(row)



mat_c = np.dot(matrixA,matrixB)
for row in mat_c:
    for element in row:
        print(element)
for row in mat_c:
    for element in row:
        # Convert each element to 32-bit binary format with leading zeros
        binary_str = format(element & 0xFFFFFFFF, '032b')
        # Write the binary string to the file with spaces between every 8 bits
        f.write(binary_str)
        f.write('\n')

f.write('00100010001000101111111111111111\n')
f.write('00000000000000000000000000000000\n')






"""

line = matfile_fd.readline()

# Scan the line using the specified format
result = scanf("%1d%1d%1d%1d%1d%1d\n", line)

# Check if all 6 variables were successfully scanned
if len(result) == 6:
    calc_mod, dest, c, n, k, m = result
    # Process the variables as needed
    print(f"calc_mod: {calc_mod}, dest: {dest}, c: {c}, n: {n}, k: {k}, m: {m}")
else:
    # Handle the case where not all variables were successfully scanned
    print("Error: Not all variables could be scanned.")
#matrixA = np.array([[33, 77, 23, 0], [55, 34, 9, 0], [0, 0, 0, 0], [0, 0, 0, 0]])
#matrixB = np.array([[12, 14, 0, 0], [17, 24, 0, 0], [3, 11, 0, 0], [0, 0, 0, 0]])
matrixA = np.array([[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]])
matrixB = np.array([[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]])



binary_lines = []
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
print(binary_lines)
# Iterate over each line
for i, line in enumerate(binary_lines):
    # Iterate over each 16-bit chunk and update the corresponding matrix element

    for j in range(4):
        binary_number = line[0][j * 8:(j + 1) * 8]
        # Check if the most significant bit is 1 (indicating a negative number)
        if binary_number[0] == '1':
            # Convert binary_number to a negative signed integer
            matrixA[i][3-j] = -(256 - int(binary_number, 2))
        else:
            # Convert binary_number to a positive signed integer
            matrixA[i][3-j] = int(binary_number, 2)

# Print the resulting matrix
for row in matrixA:
    print(row)

binary_lines = []
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
print(binary_lines)
# Iterate over each line
for i, line in enumerate(binary_lines):
    # Iterate over each 16-bit chunk and update the corresponding matrix element
    for j in range(4):
        binary_number = line[0][j * 8:(j + 1) * 8]
        # Check if the most significant bit is 1 (indicating a negative number)
        #print(str(j) + ',' + str(i))
        if binary_number[0] == '1':
            # Convert binary_number to a negative signed integer
            matrixB[3-j][i] = -(256 - int(binary_number, 2))
        else:
            # Convert binary_number to a positive signed integer
            matrixB[3-j][i] = int(binary_number, 2)

# Print the resulting matrix
for row in matrixB:
    print(row)



mat_c = np.dot(matrixA,matrixB)
for row in mat_c:
    for element in row:
        print(element)
for row in mat_c:
    for element in row:
        # Convert each element to 32-bit binary format with leading zeros
        binary_str = format(element & 0xFFFFFFFF, '032b')
        # Write the binary string to the file with spaces between every 8 bits
        f.write(binary_str)
        f.write('\n')


line = matfile_fd.readline()

# Scan the line using the specified format
result = scanf("%1d%1d%1d%1d%1d%1d\n", line)

# Check if all 6 variables were successfully scanned
if len(result) == 6:
    calc_mod, dest, c, n, k, m = result
    # Process the variables as needed
    print(f"calc_mod: {calc_mod}, dest: {dest}, c: {c}, n: {n}, k: {k}, m: {m}")
else:
    # Handle the case where not all variables were successfully scanned
    print("Error: Not all variables could be scanned.")
#matrixA = np.array([[33, 77, 23, 0], [55, 34, 9, 0], [0, 0, 0, 0], [0, 0, 0, 0]])
#matrixB = np.array([[12, 14, 0, 0], [17, 24, 0, 0], [3, 11, 0, 0], [0, 0, 0, 0]])
matrixA = np.array([[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]])
matrixB = np.array([[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]])



binary_lines = []
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
print(binary_lines)
# Iterate over each line
for i, line in enumerate(binary_lines):
    # Iterate over each 16-bit chunk and update the corresponding matrix element

    for j in range(4):
        binary_number = line[0][j * 8:(j + 1) * 8]
        # Check if the most significant bit is 1 (indicating a negative number)
        if binary_number[0] == '1':
            # Convert binary_number to a negative signed integer
            matrixA[i][3-j] = -(256 - int(binary_number, 2))
        else:
            # Convert binary_number to a positive signed integer
            matrixA[i][3-j] = int(binary_number, 2)

# Print the resulting matrix
for row in matrixA:
    print(row)

binary_lines = []
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
line = matfile_fd.readline()
binary_lines.append(scanf("%s\n", line))
print(binary_lines)
# Iterate over each line
for i, line in enumerate(binary_lines):
    # Iterate over each 16-bit chunk and update the corresponding matrix element
    for j in range(4):
        binary_number = line[0][j * 8:(j + 1) * 8]
        # Check if the most significant bit is 1 (indicating a negative number)
        #print(str(j) + ',' + str(i))
        if binary_number[0] == '1':
            # Convert binary_number to a negative signed integer
            matrixB[3-j][i] = -(256 - int(binary_number, 2))
        else:
            # Convert binary_number to a positive signed integer
            matrixB[3-j][i] = int(binary_number, 2)

# Print the resulting matrix
for row in matrixB:
    print(row)

for i in range(32768):
    mat_d = np.dot(matrixA,matrixB) + mat_c
    mat_c = mat_d
for row in mat_d:
    for element in row:
        print(element)
for row in mat_d:
    for element in row:
        # Convert each element to 32-bit binary format with leading zeros
        binary_str = format(element & 0xFFFFFFFF, '032b')
        # Write the binary string to the file with spaces between every 8 bits
        f.write(binary_str)
        f.write('\n')

f.write('00000000000000001111111111111111\n')



"""





matfile_fd.close()
f.close()