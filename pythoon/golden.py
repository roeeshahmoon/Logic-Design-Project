import numpy as np
import os
import zipfile

def expand_matrix(input_matrix, target_rows, target_columns):
    output_matrix = [[0] * target_columns for _ in range(target_rows)]

    for i in range(len(input_matrix)):
        for j in range(len(input_matrix[i])):
            output_matrix[i][j] = input_matrix[i][j]

    return output_matrix


def BintoHex(binstr: str) -> str:
    integer_num = int(binstr, 2)
    hex_string = hex(integer_num)
    return hex_string


def HextoBin(hexstr: str) -> str:
    integer_num = int(hexstr, 16)
    binary_string = bin(integer_num)[2:]  # [2:] is used to remove the '0b' prefix
    return binary_string


def string_to_binary(input_string):
    binary_string = ""
    for char in input_string:
        # Get ASCII value of the character
        ascii_value = ord(char)
        # Convert ASCII value to binary and remove the '0b' prefix
        binary_representation = bin(ascii_value)[2:]
        # Ensure each binary representation is 8 characters long by padding with zeros if necessary
        binary_representation = binary_representation.zfill(8)
        # Append the binary representation to the binary string
        binary_string += binary_representation
    return binary_string


def write_Mat_to_file(file_mat, Mat, delimiter=','):
    for row in Mat:
        file_mat.write(delimiter.join(map(str, row)))
        file_mat.write('\n')
    file_mat.write("-" * 100)


def write_SP_to_file(file_SP, SP_Arr, delimiter=','):
    for Mat in SP_Arr:
        for row in Mat:
            file_SP.write(delimiter.join(map(str, row)))
            file_SP.write('\n')
        file_SP.write('\n')
    file_SP.write("-" * 100)


def ReadModeBit(ControlReg_Str_reverse):
    return ControlReg_Str_reverse[::-1][1]


def WriteReadTarget(ControlReg_Str_reverse):
    ControlReg_Str = ControlReg_Str_reverse[::-1]
    WriteTarget = (ControlReg_Str[2:4])[::-1]
    ReadTarget = (ControlReg_Str[4:6])[::-1]
    return [WriteTarget, ReadTarget]


def ReadNKM(ControlReg_Str_reverse):
    ControlReg_Str = ControlReg_Str_reverse[::-1]
    N_str = (ControlReg_Str[8:10])[::-1]
    K_str = (ControlReg_Str[10:12])[::-1]
    M_str = (ControlReg_Str[12:14])[::-1]

    # print("this is N_str", N_str)
    # print("this is K_str", K_str)
    # print("this is M_str", M_str)

    N = int(N_str, 2) + 1
    K = int(K_str, 2) + 1
    M = int(M_str, 2) + 1

    # print("this is read N", N)
    # print("this is read K", K)
    # print("this is read M", M)

    return [N, K, M]


def generate_random_binary(length):
    return ''.join(str(np.random.choice([0, 1])) for i in range(length))


def multiply_matrices(A, B, SP_Arr, ControlReg_Str_reverse, file_param, Max_Dim, file_mat_res, file_SP, file_flags_res, Test,Bus_Width):
    N, K, M = ReadNKM(ControlReg_Str_reverse)
    mode_bit = ReadModeBit(ControlReg_Str_reverse)
    WriteTarget, ReadTarget = WriteReadTarget(ControlReg_Str_reverse)
    WriteSP = int(WriteTarget, 2)
    ReadSP = int(ReadTarget, 2)

    file_param.write(f"\nControl Register Random in Test {Test + 1}:\n")
    file_param.write(f"N = {N}, K = {K}, M = {M}\n")
    file_param.write(f"mode bit = {mode_bit}\n")
    file_param.write(f"WriteSP = {WriteSP}, ReadSP = {ReadSP}\n")
    if Bus_Width == 16:
        data_type = np.int16
    elif Bus_Width == 32:
        data_type = np.int32
    else:
        data_type = np.int64
    if mode_bit == '1':
        C = SP_Arr[ReadSP]
    else:
        C = np.zeros((Max_Dim, Max_Dim),dtype=data_type)

    flags = np.zeros((Max_Dim,Max_Dim),dtype=int)
    new_res = np.zeros((Max_Dim, Max_Dim),dtype=data_type)
    for row in range(Max_Dim):
        if Bus_Width == 16:

            A_mul_B_ = np.int16(0)
            temp_res = np.int16(0)
            temp_prev = np.int16(0)
        elif Bus_Width == 32:

            A_mul_B_ = np.int32(0)
            temp_res = np.int32(0)
            temp_prev = np.int32(0)
        else:

            A_mul_B_ = np.int64(0)
            temp_res = np.int64(0)
            temp_prev = np.int64(0)

        for col in range(Max_Dim):
            for i in range(Max_Dim):
                temp_prev = temp_res
                A_mul_B = A[row][i].astype(data_type)*B[i][col].astype(data_type)
                temp_res = A_mul_B + temp_prev
                if (temp_res <= 0 and A_mul_B > 0 and temp_prev > 0)or(temp_res >= 0 and A_mul_B < 0 and temp_prev < 0) :
                    flags[row][col] = 1

            temp_prev = temp_res
            temp_res +=C[row][col]
            if (temp_res <= 0 and temp_prev > 0 and C[row][col] > 0 ) or (temp_res >= 0 and temp_prev < 0 and C[row][col] < 0) :
                flags[row][col] = 1
            A_mul_B = 0
            new_res[row][col] = temp_res
            temp_res = 0



    #A_mul_B = np.dot(A.astype(data_type), B.astype(data_type))
    #new_res = C + A_mul_B
    SP_Arr[WriteSP] = new_res

    # Write matrices to files
    file_mat_res.write(f"\nMat Res in Test {Test + 1} is: \n\n")
    write_Mat_to_file(file_mat_res, new_res)
    file_SP.write(f"\nScratchPad in Test {Test + 1} is: \n\n")
    write_SP_to_file(file_SP, SP_Arr)
    file_flags_res.write(f"\nFlags in Test {Test + 1} is: \n\n")
    write_Mat_to_file(file_flags_res, flags)
    return SP_Arr


def writecontrolreg(ControlRegStr, instrections, BusWidth, AddressWidth, pstrb_i):
    pwdata_i = int(ControlRegStr, 2)
    paddr_i = 0
    instrections.write(f"{pwdata_i},{paddr_i},{pstrb_i}\n")


def controlreg(Max_Dim: int, SPN: int) -> str:
    N = np.random.randint(Max_Dim)
    K = np.random.randint(Max_Dim)
    M = np.random.randint(Max_Dim)

    # N = 1
    # K = 1
    # M = 1
    # print("N normal Rand is: ", N +1)
    # print("K normal Rand is: ", K + 1)
    # print("M normal Rand is: ", M + 1)

    ControlReg = 0b0

    # Set the start bit (bit 0)
    ControlReg |= (0b0)

    # Set the mode bit (bit 1)
    ControlReg |= (np.random.randint(2) << 1)
    #set mode bit to 1 to chek flags
    ControlReg |= (1 << 1)
    # Set the write target bits (bits 2 to 3)
    ControlReg |= (np.random.randint(SPN) << 2)
    #set write target always to 1 to make overflow to chek flags because we read also from 1
    ControlReg |= (0 << 2)
    # Set the read target bits (bits 4 to 5)
    ControlReg |= (np.random.randint(SPN) << 4)
    # set read target always to 1 to make overflow to chek flags because we write also from 1
    ControlReg |= (0 << 4)
    # Not in use (bits 6 to 7)
    ControlReg |= (0b00 << 6)

    # Dimension N (bits 8 to 9)
    ControlReg |= (N << 8)

    # Dimension K (bits 10 to 11)
    ControlReg |= (K << 10)

    # Dimension M (bits 12 to 13)
    ControlReg |= (M << 12)

    # Not in use (bits 14 to 15)
    ControlReg |= (0b11 << 14)

    # Print the binary representation of ControlReg
    ControlReg_Str = bin(ControlReg)[2:].zfill(16)
    return ControlReg_Str

def safe_multiply_and_add(value, multiplier, shift, DataWidth):
    """
    Safely multiplies `multiplier` by 2 raised to the power of (`shift` times `DataWidth`),
    and adds it to `value` to prevent overflow.
    """
    # Convert to a higher precision data type to prevent overflow
    result = np.int64(value) + np.int64(multiplier) * (2 ** (shift * DataWidth))
    return result

def main():
    # Get the path of the current Python script
    script_path =input('Enter the path to 206564759_316015411 directory files')
    Num_Tests = int(input('Enter number of tests'))
    # Define the path to the directory
    directory_path =os.path.join(script_path, '206564759_316015411\\verifcation_files')

    # Ensure the directory exists
    if not os.path.exists(script_path):
        script_path = input('incorrect or illgel path Enter another path for verifacation files')
        Num_Tests = int(input('Enter number of tests'))
    # Define the file name
    file_name  = ['Bus_File.txt', 'Param_File.txt','Mat_Res.txt', 'SP.txt','Mat_A.txt', 'Mat_B.txt', 'Flags_Res.txt']
    file_path = [os.path.join(directory_path, file_name[i]) for i in range(7)]
    instrections = open(file_path[0], 'w')
    file_param = open(file_path[1], 'w')
    file_mat_res = open(file_path[2], 'w')
    file_SP = open(file_path[3], 'w')
    file_mat_A = open(file_path[4], 'w')
    file_mat_B = open(file_path[5], 'w')
    file_flags_res = open(file_path[6], 'w')
    # Parmeters Randomised
    BusWidth = np.random.choice([64,32,16])#randomize BUS WIDTH parameter for DUT
    DataWidth = np.random.choice([16,8,4])#randomize DATA WIDTH parameter for DUT
    AddressWidth = np.random.choice([16, 24, 32])#randomize ADDR WIDTH parameter for DUT
    SPN = np.random.choice([1, 2, 4])#randomize SP NTARGETS parameter for DUT
    Max_Dim = BusWidth // DataWidth
    while DataWidth > BusWidth // 2 or Max_Dim>4:
        DataWidth = np.random.choice([8, 16, 32])
        Max_Dim = BusWidth // DataWidth

    if BusWidth == 16:
        Bus_type = np.int16
        temp = np.int16(0)
    elif BusWidth == 32:
        Bus_type = np.int32
        temp = np.int32(0)
    else:
        Bus_type = np.int64
        temp = np.int64(0)
    SP_Arr = [np.zeros((Max_Dim, Max_Dim), dtype=Bus_type) for i in range(SPN)]
    file_SP.write(f"\nScratchPad Before Tests: \n\n")
    write_SP_to_file(file_SP, SP_Arr)


    file_param.write(f"\nNumbers of Tests: {Num_Tests}\n")
    file_param.write("\n" + "*" * 100 + "\n")
    file_param.write(f"\nParmeters of Design:\n")
    file_param.write(f"BusWidth = {BusWidth}, DataWidth = {DataWidth}\n")
    file_param.write(f"AddressWidth = {AddressWidth}, SPN = {SPN}\n")
    file_param.write(f"Max_Dim = {Max_Dim}\n")
    file_param.write("\n" + "*" * 100 + "\n")

    # Signals Bus
    pwdata_i = ""
    paddr_i = ""
    if DataWidth == 8:
        data_type = np.int8
    elif DataWidth == 16:
        data_type = np.int16
    else:
        data_type = np.int32

    A_reg = np.zeros((Max_Dim, Max_Dim),dtype=data_type)
    B_reg = np.zeros((Max_Dim, Max_Dim),dtype=data_type)
    for Test in range(Num_Tests):
        # Generate random matrices A and B
        ControlRegStr = controlreg(Max_Dim, SPN)

        pstrb_i = np.random.randint(1,2**(Max_Dim-1)+1)
        pstrb_i_s = ""
        var = pstrb_i
        for k in range(Max_Dim):
             pstrb_i_s += str(var%2)#casting to binary string for the APB
             var = var//2

        pstrb_i_s = pstrb_i_s[::-1]
        # print(ControlRegStr)
        writecontrolreg(ControlRegStr, instrections, BusWidth, AddressWidth, pstrb_i)
        ControlRegStr_Start_Bit = ControlRegStr[:-1] + '1'
        # print(ControlRegStr_Start_Bit)
        N, K, M = ReadNKM(ControlRegStr)

        p = DataWidth - 1
        A = np.random.randint(-(2**p) , (2**p) - 1 , size=(Max_Dim, Max_Dim),dtype=data_type)
        B = np.random.randint(-(2**p)  , (2**p) - 1, size=(Max_Dim, Max_Dim),dtype=data_type)
        # Write for design in random
        row_A = [i for i in range(N)]
        row_B = [i for i in range(K)]

        while (row_A or row_B):
            Addr_Mat = np.random.choice([4, 8])

            if (Addr_Mat == 4 and row_A):#chosen A and didnt finsih wo write A
                A_idx = row_A.pop(0)#chosen row
                Addr_Mat += (A_idx << 5)#translate the row for the APB
                temp = np.int64(0)
                for k in range(K):
                    var = A[A_idx][k]
                    if var < 0:
                        var = 2**DataWidth + var# negative number for the APB
                    temp += var*(2**(k*DataWidth))#generate instruction for the APB data bus
                                                                    #max_dim element togther on the bus


                writeArrdata = temp
                instrections.write(f"{writeArrdata},{Addr_Mat},{pstrb_i}\n")

            elif (Addr_Mat == 8 and row_B):
                B_idx = row_B.pop(0)
                Addr_Mat += (B_idx << 5)
                temp = np.int64(0)
                for m in range(M):
                    var = B[B_idx][m].astype(Bus_type)
                    if var < 0:
                        var = 2**DataWidth + var
                    temp += var*(2**(m*DataWidth))
                writeArrdata = temp
                instrections.write(f"{writeArrdata},{Addr_Mat},{pstrb_i}\n")


        writecontrolreg(ControlRegStr_Start_Bit, instrections, BusWidth, AddressWidth, pstrb_i)
        file_param.write("\n" + "-" * 100 + "\n")


        for i in range(Max_Dim):
            for j in range(Max_Dim):
                if i > N - 1 or j > K - 1:
                    A_reg[i][j] = 0
                elif pstrb_i_s[Max_Dim-j-1] == '1':
                    A_reg[i][j] = A[i][j]
        for i in range(Max_Dim):
            for j in range(Max_Dim) :
                if i > K - 1 or j > M -1:
                    B_reg[i][j] = 0
                elif pstrb_i_s[Max_Dim-j-1] == '1':
                    B_reg[i][j] = B[i][j]


        file_mat_A.write(f"\nMat A Random in Test {Test + 1} is: \n\n")
        write_Mat_to_file(file_mat_A, A_reg[:N, :K])

        file_mat_B.write(f"\nMat B Random in Test {Test + 1} is: \n\n")
        write_Mat_to_file(file_mat_B, B_reg[:K, :M])

        SP_Arr = multiply_matrices(A_reg, B_reg, SP_Arr, ControlRegStr, file_param, Max_Dim, file_mat_res, file_SP,file_flags_res, Test,BusWidth)



    instrections.close()
    file_param.close()
    file_mat_res.close
    file_SP.close()
    file_mat_A.close()
    file_mat_B.close()
    print("\nFinish Verification Script, Upload instrections.txt to Design\n")


if __name__ == "__main__":
    main()

