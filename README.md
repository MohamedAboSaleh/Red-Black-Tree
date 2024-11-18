
# **Red-Black Tree Set Implementation**  

🚀 **Efficient Set Operations Using Red-Black Trees**  

This project implements a set data structure using a **Red-Black Tree**, offering efficient basic and complex operations. Two versions of the implementation are provided: **Python** and **Scheme**, each showcasing unique strengths.  

Inspired by the concepts from the paper ["Just Join for Parallel Ordered Sets"](https://www.cs.cmu.edu/~guyb/papers/BFS16.pdf), this implementation demonstrates high scalability and performance.  

---

## **🌟 Features**  

### ⚙️ **Basic Operations**  
| Operation   | Description                     | Time Complexity |
|-------------|---------------------------------|-----------------|
| **Insert**  | Add an element to the set       | **O(log n)**    |
| **Delete**  | Remove an element from the set  | **O(log n)**    |
| **Search**  | Find an element in the set      | **O(log n)**    |

### 🔗 **Complex Operations**  
| Operation       | Description                                         | Time Complexity               |
|------------------|-----------------------------------------------------|-------------------------------|
| **Union**        | Combine two sets into one                          | **O(m log((n/m)+1))**         |
| **Intersection** | Find common elements between two sets              | **O(m log((n/m)+1))**         |
| **Difference**   | Identify elements in one set but not in the other  | **O(m log((n/m)+1))**         |

The use of **Red-Black Trees** ensures balanced structure and efficient access to elements, achieving logarithmic complexity for basic operations.

---

## **📊 Performance Comparison**  

### **Python**  
✅ **Advantages**:  
- Enables **multi-threading** for faster performance on large datasets.  
- Readable and beginner-friendly code structure.  
- Easy debugging process.  

⚠️ **Disadvantages**:  
- Recursion is resource-intensive, affecting performance in deeply recursive tasks.  



### **Scheme**  
✅ **Advantages**:  
- Highly **efficient recursion handling**, making it faster for recursive operations.  
- Supports functional programming and experimentation with **first-class procedures** and **macros**.  

⚠️ **Disadvantages**:  
- Smaller community and fewer support resources.  
- Limited commercial applications; mainly used in academic research.  

### **Why is Scheme Faster?**  
Scheme's functional nature and optimized recursion handling outperform Python in this context. Scheme uses **tail recursion**, which minimizes call stack overhead, while Python's recursion can be resource-intensive.  

---

## **💻 Usage Instructions**  

### **Running the Code**  
1. Ensure the file `data_struct(1000x1000).txt` is in the root directory.  
2. Run the Python or Scheme script. The program will:  
   - **Read** the data file.  
   - **Construct** 1,000 trees (each with 1,000 nodes).  
   - **Perform union** of all trees.  
   - **Delete** all nodes from the final merged tree.  

For Python:  
```
python3 main.py
```

---

## 📂 Data and Results

### **Dataset**
The dataset consists of 1,000 trees, each containing 1,000 nodes, representing a total of 1,000,000 elements.

### **Performance Table**
  
| Language       | Execution Time         | Multithreading   |
|------------------|----------------------|------------------|
| **Python**        | 156 seconds         |    yes           |
| **Scheme** | 54 seconds                 |    no            |

---

## 📜 Acknowledgments
This project is inspired by the paper ["Just Join for Parallel Ordered Sets"](https://www.cs.cmu.edu/~guyb/papers/BFS16.pdf). Special thanks to the academic resources that guided this implementation.

---
## 🚀 Future Enhancements
While there are no immediate plans for new features, the code could be extended to other languages like C++ and Java to explore further optimizations and portability.


