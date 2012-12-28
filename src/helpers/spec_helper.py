#TODO: change input to formulas

def and_properties(properties):
    properties = list(properties)
    if len(properties) == 0:
        return 'true'

    return ' && '.join(['(' + str(p) + ')' for p in properties])
