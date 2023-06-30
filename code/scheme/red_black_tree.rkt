#lang racket


(struct tree (root)#:mutable)

(struct node(data parent left right color)#:mutable)

(define GlobNullNode (λ()(
                 let([v(node #f #f #f #f 'black)])
                  (set-node-parent! v v)
                  (set-node-left! v v)
                  (set-node-right! v v)
                  v)))

(define make-node(λ(data)
                   (node data GlobNullNode GlobNullNode GlobNullNode 'red)))

(define GlobNullNode-Tree(λ()
                           (tree GlobNullNode)))

;create a tree with one node
(define one-node-tree(λ(v)
                       (unless(eq? v GlobNullNode)
                         (set-node-color! v 'black))
                       (tree v)))

;;BST insertion
(define BST-insert(λ(root v)
                   (if(eq? root GlobNullNode)
                      v
                      (if(<(node-data v) (node-data root))
                         (let()
                           (define tmp-left(BST-insert(node-left root)v))
                           (set-node-left! root tmp-left)
                           (set-node-parent! tmp-left root)
                           root)
                         (let()
                           (define tmp-right(BST-insert(node-right root)v))
                           (set-node-right! root tmp-right)
                           (set-node-parent! tmp-right root)
                           root
                           )))))

;boolian function wether the parent is red
(define parent-red? (λ(v)
                        (if(eq?(node-parent v) GlobNullNode)
                           #f
                           (if(eq?(node-color(node-parent v )) 'red)
                              #t
                              #f))))

;boolean func if the node v is black(#f) or red(#t)
(define red? (λ(v)
                        (if(eq? v GlobNullNode)
                           #f
                           (if (eq?(node-color v ) 'red)
                               #t
                               #f))))

;while
(define-syntax while
  (syntax-rules()
    ((_ pred b1 ...)
     (let loop () (when pred b1 ... (loop))))))

(define fix-after-insert(λ(t v)
                          (if (and (parent-red? v)(eq? (node-parent v) (tree-root t)))
                             (begin
                               (set-node-color! v 'black))
                             (begin
                               (while (parent-red? v)
                                      (if(eq?(node-parent v)(node-right(node-parent(node-parent v))))
                                         (let()
                                           (define uncle(node-left(node-parent(node-parent v))))
                                           (if(red? uncle);uncle is red
                                              (begin
                                                (set-node-color! uncle 'black)
                                                (set-node-color! (node-parent v) 'black)
                                                (set-node-color! (node-parent(node-parent v)) 'red)
                                                (set! v(node-parent(node-parent v))))
                                              (begin ;uncle is black
                                                (when(eq? v(node-left (node-parent v)))
                                                  (begin
                                                    (set! v(node-parent v))
                                                    (right-rotate t v )))
                                                (set-node-color! (node-parent v) 'black)
                                                (set-node-color! (node-parent(node-parent v)) 'red)
                                                (left-rotate t (node-parent (node-parent v))))))
                                         (let ()
                                           (define uncle (node-right(node-parent(node-parent v))));uncle-> right grandparent child
                                           (if(red? uncle)
                                              (begin
                                                (set-node-color! uncle 'black)
                                                (set-node-color! (node-parent v) 'black)
                                                (set-node-color! (node-parent(node-parent v)) 'red)
                                                (set! v(node-parent (node-parent v))))
                                              (begin ;uncle is black
                                                (when(eq? v (node-right(node-parent v)))
                                                  (begin
                                                    (set! v (node-parent v))
                                                    (left-rotate t v)))
                                                (set-node-color! (node-parent v ) 'black)
                                                (set-node-color! (node-parent(node-parent v)) 'red)
                                                (right-rotate t (node-parent (node-parent v))))))))
         
                                 (set-node-color! (tree-root t) 'black)))))
;rotations
(define left-rotate (λ(t x)
                      (define y(node-right x))
                      (set-node-right! x (node-left y))
                      (unless (eq?(node-left y) GlobNullNode)
                        (set-node-parent!(node-left y)x))
                      (set-node-parent! y (node-parent x))
                      (cond [(eq? (node-parent x) GlobNullNode)
                             (set-tree-root! t y)]
                            [(eq? x (node-left(node-parent x)))
                             (set-node-left!(node-parent x) y)]
                            [else
                             (set-node-right! (node-parent x) y)])
                      (set-node-left! y x)
                      (set-node-parent! x y)))

(define right-rotate (λ(t y)
                      (define x(node-left y))
                      (set-node-left! y (node-right x))
                      (unless (eq?(node-right x) GlobNullNode)
                        (set-node-parent!(node-right x) y))
                      (set-node-parent! x (node-parent y))
                      (cond [(eq? (node-parent y) GlobNullNode)
                             (set-tree-root! t x)]
                            [(eq? y (node-right(node-parent y)))
                             (set-node-right!(node-parent y) x)]
                            [else
                             (set-node-left! (node-parent y) x)])
                      (set-node-right! x y)
                      (set-node-parent! y x)))

(define RBT-insert(λ(t v)
                  (if(eq?(tree-root t) GlobNullNode)
                     (one-node-tree v)
                     (begin
                       (BST-insert(tree-root t)v)
                       (fix-after-insert t v)))))



(define RBT-search(λ(x num)
                   (if(eq? x GlobNullNode)
                      GlobNullNode
                      (if(=(node-data x) num)
                         x
                         (if(<= num(node-data x))
                            (RBT-search (node-left x) num)
                            (RBT-search (node-right x) num))))))

(define RBT-transplant(λ(t u v)
                       (cond [(eq?(node-parent u) GlobNullNode)
                              (set-tree-root! t v)]
                             [(eq? u (node-left (node-parent u)))
                              (set-node-left! (node-parent u) v)]
                             [else
                              (set-node-right! (node-parent u) v)])
                       (unless (eq? v GlobNullNode)
                         (set-node-parent! v (node-parent u)))))
;;;;;;Deletion
;min in the left subtree
(define RBT-min(λ(x)
                (if(eq? (node-left x ) GlobNullNode)
                   x
                   (RBT-min(node-left x)))))
(define RBT-fix-delete(λ (t x)
                       (let()
                         (define s 0)
                         (while(and (not(eq? x (tree-root t))) ((eq? (node-color x) 'black)))
                               (if(eq? x (node-left (node-parent x))) 
                                  (begin
                                    (set! s (node-right (node-parent  x)))
                                    ;case3.1
                                    (when(eq? (node-color s) 'red)
                                      (set-node-color! s 'black)
                                      (set-node-color! (node-parent x) 'red)
                                      (left-rotate t (node-parent x))
                                      (set! s (node-right (node-parent x))))
                                    
                                    ;case3.2
                                    (if(and(eq?(node-color (node-left s)) 'black) (eq?(node-color (node-right s)) 'black) (eq?(node-color  s) 'black))
                                           (begin
                                             (set-node-color! s 'red)
                                             (set! x (node-parent x)))
                                           (begin
                                             (when (eq?(node-color (node-right s)) 'black);case 3.3
                                               (set-node-color!(node-left s) 'black)
                                               (set-node-color! s 'red)
                                               (right-rotate t s)
                                               (set! s (node-right (node-parent x))))
                                             ;case3.4
                                             (set-node-color! s (node-color(node-parent x)))
                                             (set-node-color! (node-parent x) 'black)
                                             (set-node-color! (node-right s)'black)
                                             (left-rotate t (node-parent x))
                                             (set! x (tree-root t)))))
                                    ;else
                                    (begin
                                      (set! s (node-left(node-parent x)))
                                      (when (eq? (node-color s ) 'red);case3.1
                                        (set-node-color! s 'black)
                                        (set-node-color! (node-parent x) 'red)
                                        (right-rotate t (node-parent x))
                                        (set! s (node-left(node-parent x))))
                                      (if(and(eq?(node-color (node-left s)) 'black) (eq?(node-color (node-right s)) 'black) (eq?(node-color  s) 'black));case3.2
                                           (begin
                                             (set-node-color! s 'red)
                                             (set! x (node-parent x)))
                                           (begin
                                             (when (eq?(node-color (node-right s)) 'black);case 3.3
                                               (set-node-color!(node-right s) 'black)
                                               (set-node-color! s 'red)
                                               (left-rotate t s)
                                               (set! s (node-left (node-parent x))))
                                             ;case3.4
                                             (set-node-color! s (node-color(node-parent x)))
                                             (set-node-color! (node-parent x) 'black)
                                             (set-node-color! (node-left s)'black)
                                             (right-rotate t (node-parent x))
                                             (set! x (tree-root t)))))))
                                  (set-node-color! x 'black))))
;search and delete
(define RBT-delete(λ(t num)
                   (let ()
                     (define del(RBT-search(tree-root t) num))
                     (define color (node-color del))
                     (define x(make-node 0))
                     (define y del)
                     (cond [(eq? (node-left del) GlobNullNode )
                            (begin
                              (set! x (node-right del))
                              (RBT-transplant t del (node-right del)))]
                           [else
                            (begin
                              (set! y (RBT-min (node-right del)))
                              (set! color (node-color y))
                              (set! x (node-right y ))
                              (if (eq? (node-parent y ) del)
                                  (unless(eq?(node-left y)GlobNullNode)
                                    (set-node-parent! x y))
                                  (begin
                                    (RBT-transplant t y (node-right y))
                                    (set-node-right! y (node-right del))
                                    (set-node-parent! (node-right y) y)))
                              (RBT-transplant t del)
                              (set-node-left! y (node-left del))
                              (set-node-parent! (node-left y) y)
                              (set-node-color! y (node-color del)))])
                     (when (and (eq? color 'black)(not (eq? x GlobNullNode)))
                       (RBT-fix-delete t x)))))




(define get-black-height (λ(node)
                           (cond[ (eq? node GlobNullNode)
                                  1]
                                [else
                                 (define temp node)
                           (define x 0)
                           (while (not (eq? temp GlobNullNode))
                                  (cond[ (eq? (node-color temp) 'black)
                                      (set! x (+ x 1))])
                              
                                  (set! temp (node-left temp)))
                           (+ x 1)])))
                                



  (define get-color(λ(n)
                    (cond [(eq? n GlobNullNode)
                           'black]
                          [else
                           (node-color n)])))


(define balanced-join(λ (l r k color)
                       
                       (define e(make-node k))
                       (set-node-color! e color)
                       (set-node-left! e l)
                       (set-node-right! e r)
                       e))

(define join-left-rotate(λ(x)
                          (define root (node-right x))
                          (define lsub (node-left root ))
                          (set-node-left! root x)
                          (set-node-right! x lsub)
                          root))

(define join-right-rotate(λ(x)
                          (define root (node-left x))
                          (define rsub (node-right root ))
                          (set-node-left! x rsub)
                           (set-node-right! root x)
                          root))

(define joinRightRBT(λ (TL k TR)
                     (cond [(and (eq? (get-color TL) 'black) (= (get-black-height TL) (get-black-height TR)))
                            (balanced-join TL TR k 'red)]
                           [else
                            (define t(make-node (node-data TL)))
                            (set-node-color! t (node-color TL))
                            (set-node-left! t(node-left TL))
                            (set-node-right! t (joinRightRBT (node-right TL) k TR))
                            (cond[(and (eq? (get-color TL) 'black) (eq? (get-color(node-right t)) 'red) (eq? (get-color (node-right (node-right t))) 'red))
                                  (set-node-color! (node-right (node-right t)) 'black)
                                  (join-left-rotate t)
                                  ]
                                 [else t])])))

(define joinLeftRBT(λ (TL k TR)
                     (cond [(and (eq? (get-color TR) 'black) (= (get-black-height TL) (get-black-height TR)))
                            (balanced-join TL TR k 'red)]
                           [else
                            (define t(make-node (node-data TR)))
                            (set-node-color! t (get-color TR))
                            (set-node-left! t(joinLeftRBT TL k (node-left TR)))
                            (set-node-right! t(node-right TR))
                            (cond[(and (eq? (get-color TR) 'black) (eq? (get-color(node-left t)) 'red) (eq? (get-color (node-left (node-left t))) 'red))
                                  (set-node-color! (node-left (node-left t)) 'black)
                                  (join-right-rotate t)
                                  ]
                                 [else t])])))
                            
                            
  (define join(λ(TL k TR)
                
                (cond[(> (get-black-height TL) (get-black-height TR))
                      
                      (define t (joinRightRBT TL k TR))
                      (cond[(and (eq? (get-color t) 'red) (eq?(get-color(node-right t)) 'red))
                            (set-node-color! t 'black)])
                      t]
                     [(< (get-black-height TL) (get-black-height TR))
                      (define t (joinLeftRBT TL k TR))
                      (cond[(and (eq? (get-color t) 'red) (eq?(get-color(node-left t)) 'red))
                            (set-node-color! t 'black)])
                      t]
                     [(and (eq? (get-color TL) 'black) (eq? (get-color TR) 'black))
                      (define tt (balanced-join TL TR k 'red))
                      tt]
                     [else (define tt (balanced-join TL TR k 'black))
                tt ])))
                     

(define split(λ(T k)
               (cond[(eq? T GlobNullNode)
                     (list GlobNullNode #f GlobNullNode)]
                    [(= k (node-data T))
                     (list (node-left T) #t (node-right T))]
                    [(< k (node-data T))
                     (define res (split (node-left T) k))
                     (define L (car res))
                     (define b (car(cdr res)))
                     (define R (car(cddr res)))
                     (define temp (join R (node-data T) (node-right T)))
                     (list L b temp)]
                    [else
                     (define res1 (split (node-right T) k))
                     (define L1 (car res1))
                     (define b1 (car(cdr res1)))
                     (define R1 (car(cddr res1)))
                     (define temp1 (join (node-left T) (node-data T) L1))
                     (list temp1 b1 R1)])))

                 
                     
(define union(λ(t1 t2)
               (cond [(eq? t1 GlobNullNode)
                       t2]
                     [(eq? t2 GlobNullNode)
                      t1]
                     [else
                      (define res (split t1 (node-data t2)))
                      (define L (car res))
                      (define b (car(cdr res)))
                      (define R (car(cddr res)))
                      (define TL (union L (node-left t2)))
                      (define TR (union R (node-right t2)))
                      (join TL (node-data t2) TR)])))

                      
(define inorder (λ(root1)
                  
                  (cond [(not (eq? root1 GlobNullNode))
                        (inorder (node-left root1))
                              (display (node-data root1))
                              (display ", ")
                              (inorder (node-right root1))]
                        [else (void)])))

(define expose(λ(T)
                (list (node-left T) (node-data T) (node-right T))))
(define splitLast(λ(T)
                   (define temp (expose T))
                   (define L (car temp))
                   (define k (car(cdr temp)))
                   (define R (car(cddr temp)))
                   (cond[(eq? R GlobNullNode)
                         (list L k)]
                        [else
                         (define temp1 (splitLast R))
                         (define Tt (car temp1))
                         (define kt (car(cdr temp1)))
                         (define joined (join L k Tt))
                         (list joined kt)])))


(define join2(λ(L R)
               (cond [(eq? L GlobNullNode)
                      R]
                     [else
                      (define temp (splitLast L))
                      (define Lt (car temp))
                      (define k (car(cdr temp)))
                      (define joined (join Lt k R))
                      joined])))
                    
(define intersection(λ(t1 t2)
                     (cond[(or(eq? t1 GlobNullNode) (eq? t2 GlobNullNode))
                           GlobNullNode]
                          [else
                           
                           (define temp (expose t1))
                           (define l1 (car temp))
                           (define k1 (car(cdr temp)))
                           (define r1 (car (cddr temp)))
                           (define sp (split t2 k1))
                           (define t_lower (car sp))
                           (define b (car(cdr sp)))
                           (define t_higher (car(cddr sp)))
                           (define lt (intersection l1 t_lower))
                           (define rt (intersection r1 t_higher))
                           (cond [(eq? b #t)
                                  
                                  (define joined1 (join lt k1 rt))
                                  joined1]
                                 [else
                                  (define joined2 (join2 lt rt))
                                  joined2])])))
                               
                           
                           
(define difference(λ(t1 t2)
                   (cond [(eq? t1 GlobNullNode)
                         GlobNullNode]
                        [(eq? t2 GlobNullNode)
                         t1]
                        [else
                         (define temp (expose t1))
                         (define l1 (car temp))
                         (define k1 (car(cdr temp)))
                         (define r1 (car (cddr temp)))
                         (define sp (split t2 k1))
                         (define t_lower (car sp))
                         (define b (car(cdr sp)))
                         (define t_higher(car(cddr sp)))
                         (define lt (difference l1 t_lower))
                         (define rt (difference r1 t_higher))
                         (cond [(eq? b #t)
                                (define joined2 (join2 lt rt))
                                joined2]
                               [else
                                (define joined1 (join lt k1 rt))
                                joined1])])))
                         


  (define count-nodes(λ(root)
                       (cond[(eq? root GlobNullNode)
                             0]
                            [else
                             (+ 1 (+ (count-nodes (node-left root))(count-nodes(node-right root))))])))


(define union-all(λ(final trees)
                   (cond [(eq? (length trees) 0)
                              final]
                         [else                   
                   (begin
                     (set! final (union final (tree-root (car trees))))
                     (union-all final (cdr trees)))])))
                   
                    

 
                       


(define create-tree-from-line(λ(line)
                               (set! line (string-trim line))
                                (define splited (string-split line ","))
                               (define mytree (one-node-tree (make-node (string->number (car splited)))))
                               (set! splited (cdr splited))
                                (map (lambda (x)
                                       (cond [(and (not (eq? (string->number x) #f)) (eq? (RBT-search (tree-root mytree) (string->number x)) GlobNullNode))
                                      (RBT-insert mytree (make-node (string->number x)))]
                                             [else
                                              (void)
                                             ]))
                                     splited)
                               mytree))



(define (create-trees filename)
  (define trees '())
  (with-input-from-file filename
    (lambda ()
      (let loop ()
        (let ((line (read-line)))
          (if (not (eof-object? line))
              (begin (set! trees (cons (create-tree-from-line line) trees)) (loop))
              
              trees)))))
  trees)


(define (count-all trees x)
  (cond [(eq? (length trees) 0)
         (void)]
         [else
          (begin
            (display x)
            (display " ")
            (display (count-nodes (tree-root (car trees))))
            (newline)
            (count-all (cdr trees) (+ 1 x)))]))
      
(display "started...\n")
(define start (current-inexact-milliseconds))
(define trees (create-trees "data_struct(1000x1000).txt"))
(define final (tree-root(car trees)))
(set! trees (cdr trees))
(set! final (union-all final trees))
(display "size after union all the trees: ")
(display (count-nodes final))
(define end(current-inexact-milliseconds))
(define time-took (- end start))
(display "\nbulding trees and union all took : ")
(display (/ time-took 1000))







