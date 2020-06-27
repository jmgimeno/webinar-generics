## Enumerations

Your last task is to enumerate all values from a data type.
However, since any types are infinite, we are going to introduce
a number to represent a cap on the amount of constructors used
in the value. Whenever that number goes to 0,
_no more_ items should be produced.

```haskell
class Enumerate a where
  enumerate :: Int -> [a]
```

You can see check the basic instances for integers and Booleans.
In particular, Booleans have only two options: either the cap is 0,
and then an empty list is produced, or both elements are produced
(since both `False` and `True` are simply one constructor).

Your task is to finish the `U1` instance for `GEnumerate`,
and write the instances for the rest of representation types.

Be aware that in the case of products you need to "split"
the cap between the different fields. The `split` function,
given in the code, gives you a list of splittings of a number
in two positive values. For example:

```haskell
> split 3
[(1,2), (2,1)]
```

Then, try to use a list comprehension to "iterate" over all the possible
splittings.