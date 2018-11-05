{
  :decorate
    (fn [name args ...]
      (list (sym :set) name
        (list (sym :let) [(sym :super) (list (sym :or) name (list (sym :fn) []))]
          (list (sym :fn) args ...))))}
