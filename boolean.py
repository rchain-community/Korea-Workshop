def true(x, y):
    return x

def false(x, y):
    return y

def AND(a, b):
    return a(b, false)

print("expect true")
print(AND(true, true))
# a is true
# b is true
# a(b, false)
# true(true, false)
# true

print("expect false")
print(AND(true, false))
print(AND(false, true))
print(AND(false, false))
