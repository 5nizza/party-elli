
def print_usage():
    print "OPTIONS:"
    print "-h\t\t prints this message"
    print "-i <FILE.ltl>\t loads the LTL formula from the given input file"
    print "-o <FILE.v>\t writes the verilog output to the given file"
    print
    return

def process_options():
    """For command line options processing"""
    import sys
    import getopt
    import os.path
    
    try: opts, args = getopt.getopt(sys.argv[1:], "hio:",
                                    ["help", "input=", "output="])
    except getopt.GetoptError:
        print "Error: invalid arguments. See --help for valid options."
        sys.exit(2)
        pass

    # options processing:
    input = None
    output = None
    for o,a in opts:
        if o in ("-h", "--help"): print_usage(); sys.exit()
        if o in ("-i", "--input") and input is None: input = a
        if o in ("-o", "--output") and output is None: output = a
        pass

    if input and not os.path.isfile(input):
        print "Error: input file '%s' not found"
        sys.exit(1)
        pass

    return input,output


def main():
    print "Welcome to BoSy!"

    inputFile,outputFile = process_options()
    print inputFile
    print outputFile
    

if __name__ == "__main__":
    main()
