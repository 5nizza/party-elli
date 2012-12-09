def and_properties(properties):
    if len(properties) == 0:
        return 'true'

    return ' && '.join(['(' + str(p) + ')' for p in properties])


