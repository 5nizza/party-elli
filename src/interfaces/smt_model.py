class SmtModel:
    model = None
    
    def __init__(self,modelStr):
        self.model = modelStr
        
    def get_model(self):
        return self.model