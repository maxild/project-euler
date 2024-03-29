# Each new term in the Fibonacci sequence is generated by adding the previous
# two terms. By starting with 1 and 2, the first 10 terms will be:

# 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...

# By considering the terms in the Fibonacci sequence whose values do not exceed
# four million, find the sum of the even-valued terms.

even(i) = rem(i, 2) == 0

# function Fib(n)
#     if n == 0
#         0
#     elseif n == 1
#         1
#     else
#         Fib(n-1) + Fib(n-2)
#     end
# end

# Fib(5)

# n      0  1  2  3  4  5  6  etc...
# Fib(n) 0  1  1  2  3  5  8  etc...
struct FibonacciSeq
    below::Int
end

# Julia translates 'for i in FibonacciSeq(4_000_000)' into the following code:
#   next = iterate(FibonacciSeq(4_000_000))
#   while next !== nothing
#     (i, state) = next
#     # body
#     next = iterate(iter, state)
#   end
# So to iterate over the Fibonacci sequence, we need to implement two version of Base.iterate.

# FibonacciSeq -> (Fib(n), State)), where State = (Fib(n), Fib(n-1), and Fib(n) isa Int
# The "invisible" state is a pair of integers representimg the current and previous Fibonacci numbers
function Base.iterate(seq::FibonacciSeq)
    # (Fib(1), (Fib(1), Fib(0)))
    1, (1, 0)
end

# (FibonacciSeq, State) -> (Fib(n), (Fib(n), Fib(n-1))
# The "invisible" state is a pair of integers representimg the current and previous Fibonacci numbers
function Base.iterate(seq::FibonacciSeq, state)
    # (Fib(n), Fib(n-1))
    curr, prev = state
    next = curr + prev
    if next > seq.below
        nothing
    else
        # (Fib(n+1), (Fib(n+1), Fib(n)))
        next, (next, curr)
    end
end

# required for collect not to error:
#     LoadError: MethodError: no method matching length(::FibonacciSeq)
Base.IteratorSize(seq::FibonacciSeq) = Base.SizeUnknown() # workaround

# test of iterable (FibonacciSeq) is best done using collect
collect(FibonacciSeq(100))

sumOfEvenFibs(below) = sum(fib for fib in FibonacciSeq(below) if even(fib))

# The even Fibonacci numbers LTE four million
sumOfEvenFibs(4_000_000) # 4613732

# for x in FibonacciSeq(10)
#     println(x)
# end
