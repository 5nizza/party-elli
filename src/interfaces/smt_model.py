class SmtModel:
    model = None
    
    def __init__(self,modelStr):
        self.model = modelStr
        
    def getModel(self):
        return self.model