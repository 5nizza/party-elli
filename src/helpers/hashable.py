class HashableDict(dict): # http://bob.pythonmac.org/archives/2005/03/04/frozendict/
    __slots__ = ('_hash',)
    def __hash__(self):
        rval = getattr(self, '_hash', None)
        if rval is None:
            rval = self._hash = hash(frozenset(self.iteritems()))
        return rval
