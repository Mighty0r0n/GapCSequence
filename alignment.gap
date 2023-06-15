input<raw, raw>

type Rope = extern
type typ_ali = (Rope first, Rope second)



signature sig_ali(alphabet, answer) {
    answer Ins(<alphabet, void>, answer);
    answer Del(<void, alphabet>, answer);
    answer Ers(<alphabet, alphabet>, answer);
    answer Sto(<void, void>);
    choice [answer] h([answer]);
}
algebra alg_pretty implements sig_ali(alphabet=char, answer=typ_ali) {
  typ_ali Ins(<alphabet a, void>, typ_ali x) {
    typ_ali res;
    append(res.first, a);
    append(res.first, x.first);
    append(res.second, '-');
    append(res.second, x.second);
    return res;
  }
  typ_ali Del(<void, alphabet b>, typ_ali x) {
    typ_ali res;
    append(res.first, '-');
    append(res.first, x.first);
    append(res.second, b);
    append(res.second, x.second);
    return res;
  }
  typ_ali Ers(<alphabet a, alphabet b>, typ_ali x) {
    typ_ali res;
    append(res.first, a);
    append(res.first, x.first);
    append(res.second, b);
    append(res.second, x.second);
    return res;
  }
  typ_ali Sto(<void, void>) {
    typ_ali res;
    return res;
  }
	
  typ_ali EndGap2(<Rope afirst, void>, typ_ali x, <Rope asecond, void>) {
    typ_ali res;
    append(res.first, afirst);
    append(res.first, x.first);
    append(res.first, asecond);
	  
    append(res.second, '_', size(afirst));
    append(res.second, x.second);
    append(res.second, '_', size(asecond));
    return res;
  }
  typ_ali EndGap(<void, Rope bfirst>, typ_ali x, <void, Rope bsecond>) {
    typ_ali res;
    append(res.first, '_', size(bfirst));
    append(res.first, x.first);
    append(res.first, '_', size(bsecond));
	  
    append(res.second, bfirst);
    append(res.second, x.second);
    append(res.second, bsecond);
    return res;
  }
	
  typ_ali InsX(<alphabet a, void>, typ_ali x) {
    typ_ali res;
    append(res.first, a);
    append(res.first, x.first);
    append(res.second, '=');
    append(res.second, x.second);
    return res;
  }
  typ_ali InsW(<alphabet a, void>, typ_ali x) {
    typ_ali res;
    append(res.first, a);
    append(res.first, x.first);
    append(res.second, '_');
    append(res.second, x.second);
    return res;
  }
  typ_ali DelX(<void, alphabet b>, typ_ali x) {
    typ_ali res;
    append(res.first, '=');
    append(res.first, x.first);
    append(res.second, b);
    append(res.second, x.second);
    return res;
  }
  typ_ali DelW(<void, alphabet b>, typ_ali x) {
    typ_ali res;
    append(res.first, '_');
    append(res.first, x.first);
    append(res.second, b);
    append(res.second, x.second);
    return res;
  }
  typ_ali ErsW(<alphabet a, alphabet b>, typ_ali x) {
    typ_ali res;
    append(res.first, a);
    append(res.first, x.first);
    append(res.second, b);
    append(res.second, x.second);
    return res;
  }
  

  choice [typ_ali] h([typ_ali] candidates) {
    return candidates;
  }
}

algebra alg_similarity implements sig_ali( alphabet=char, answer=int) {
    int Ins(<alphabet a, void>, int x) {      
        return x -2;
    }
    int Del(<void, alphabet b>, int x) { 
        return x -2;
    }
    int Ers(<alphabet a, alphabet b>, int x) {
        if (a == b) { 
            return x +1; 
            }
        else { 
            return x -1; 
        }      
    }
    int Sto(<void, void>) {
        return 0;
    }
    choice [int] h([int] candidates) {
        return list(maximum(candidates));
    }
}

algebra alg_enum auto enum;
algebra alg_count auto count;

grammar gra_ali uses sig_ali(axiom=Foo) {
    Foo = A;
  
  A = Ins(<CHAR, EMPTY>, I)
    | Del(<EMPTY, CHAR>, D)
    | R
    # h;

  D = Ins(<CHAR, EMPTY>, I)
    | Del(<EMPTY, CHAR>, D)
    | R
    # h;
    
  I = Ins(<CHAR, EMPTY>, I)
    | R
    # h;

  R = Ers(<CHAR, CHAR>, A)
    | Sto(<EMPTY, EMPTY>)
    # h;
}
instance global = gra_ali(alg_similarity);