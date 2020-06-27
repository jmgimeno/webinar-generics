## Get a field

This last task asks you to write "half" of a generic lens.
Roughly, a lens is the functional, composable, first-class version
of a property or field in OO, and has a _getter_ and a _setter_.
The half you are going to write is the getter.

The type class that defines `get` is more complicated than our 
previous examples. An instance of the form:

```haskell
GGet field whole part
```

means that you can get the value of a field of name `field` in a
value of type `whole`, and the result is of type `part`.
For example, if we have a data type like:

```haskell
data Person = Person { name :: String, age :: Int }
```

then the following two calls are type correct:

```haskell
> get (Proxy @"name") p  -- has type String
> get (Proxy @"age")  p  -- has type Int
```

You might be wondering what those `Proxy` arguments are.
The name of the fields is not something that exists at
the term level, it's pure type level information. A `Proxy` is
a bridge between those two worlds, allowing us to indicate
the required type level information. The use of `Proxy`s
is quite common in type level programming.

> Did we already mention that 47 Degrees Academy offers a
> course on type level techniques in Haskell?

The task requires you to write some "usual" instances,
namely for sums and metadata which we ought to ignore.
The crux of the algorithm is to traverse a product looking
for the requested field. In order to tell the compiler
to use the instance marked (2) only if (1) does not match,
we can use `OVERLAPS` and `OVERLAPPABLE` in the instances.
Note that this is enough for this example, but for real-world
scenarios you need to use type families; those are unfortunately
out of the scope of this webinar.