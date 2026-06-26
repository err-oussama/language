#  TypeScript 




## Basic Types and Variables

### Primitive Types 

TypeScript adds type annotations to standard JavaScript primitives. These are the building blocks of your data.

- `string`: Textual data.
- `number`: Both integers and floating-point numbers (JavaScript doesn't differentiate between them).
- `boolean`: true or false.
- `null`: represents an **intentional absence** of value. It is a value explicitly assigned by the programmer to indicate that a variable is deliberately empty. 
- `undefined`: represents an **unintentional absence** of value. It is the system's default state when a variable has been declared but not yet assigned a value. 
- `bigint`: For extremely large integers (rarely used in standard apps, but available).
- `symbol`: Unique and immutable identifiers (mostly used in advanced state management).

```
let userName: string = "Alice";
let age: number = 28;
let isDeveloper: boolean = true;
let bigNumber: bigint = 100000000000n;
let s: symbol = Symbol(10);
let undefined_variable; // it value is undefined
let empty = null;
```

### Arrays and Objects

How to type collections of data.

- **Arrays**: Can be typed using the `type[]` syntax or the generic `Array<type>` syntax. Both do the exact same thing, but `type[]` is more common.
- **Tuples**: A strict, fixed-length array where you know the exact type at each index.
- **Objects**: Can be typed inline, but in a real codebase, you will almost always use interface or type (covered in Section 4).

```
// Arrays
let skills: string[] = ["TypeScript", "React", "Node"];
// OR
let skillsGeneric: Array<string> = ["TypeScript", "React", "Node"];

// Tuples (Great for coordinates, key-value pairs, etc.)
let coordinates: [number, number] = [40.7128, -74.0060]; 

// Objects
let user: { id: number; userName: string } = {
  id: 1,
  userName: "Alice",
};

console.log(user.id);
console.log(user["userName"]);
user.not_exist; <- this will give undefined
```


### Type Inference vs Explici Annotation 

TypeScript is smart. You don't always have to write the type yourself.

- **Explicit Annotation**: You manually write the type (e.g., `let x: number = 5`). Use this when declaring variables without initializing them immediately, or when you need to restrict a variable to a specific subset of values.
- **Implicit Inference** : TypeScript guesses the type based on the value you assign. This keeps your code clean and readable.

```
// EXPLICIT: Required because we don't have a value yet
let score: number; 
score = 10;

// IMPLICIT: TS knows 'count' is a number because we assigned '0'
let count = 0; 
count = 5; // OK
// count = "five"; // ERROR! TS knows it must be a number.

// When inference gets it "wrong" (too broad)
// If we just wrote: let status = "active", TS infers it as a generic 'string'.
// If we want to restrict it to ONLY "active" or "inactive", we must be explicit:
let status: "active" | "inactive" = "active";
```

### Variables: `let`, `const`, and why we avoid `var`

Standard JavaScript scoping rules apply, but TypeScript enforces them at compile time.


- `const`: Cannot be reassigned. (Note: Objects and arrays declared with `const` can still have their contents mutated, but the variable reference itself cannot change). TypeScript infers `const` primitives as exact literal types.
- `let`: Can be reassigned, but only to the same type. It is block-scoped (only exists inside the `{}` where it was declared).
- `var`: **Avoid completely**. It is function-scoped (leaks out of blocks) and can be redeclared, leading to unpredictable bugs. Modern TypeScript linters will usually flag `var` as an error.

```
// const: Inferred as the exact string literal "https://api.example.com"
const API_URL = "https://api.example.com"; 
// API_URL = "new url"; // ERROR! Cannot reassign a const.

// let: Inferred as 'number'. Block scoped.
let retryCount = 0; 
retryCount = 1; // OK

// var: Outdated. Do not use.
var oldVariable = "don't use me";
```


## Functions 

### Typing parameters and Return values

Every function in a TypeScript codebase will have types attached to its inputs (parameters) and its output (return value). The syntax uses colons (`:`) to declare what each piece of data must be.
```
// Syntax: function name(param: type, param: type): returnType {}

function add(a: number, b: number): number {
  return a + b;
}

add(5, 10);    // OK
// add(5, "10"); // ERROR! Argument of type 'string' is not assignable to 'number'.
```

If you forget the return type, TypeScript will infer it from what you return. However, explicitly writing it is considered a best practice in teams because it acts as documentation and catches bugs if you accidentally return the wrong thing.

```
// Inferred return type: TypeScript knows this returns a string
function greet(name: string) {
  return `Hello, ${name}`;
}

// Explicit return type: Safer and more readable for teammates
function greetExplicit(name: string): string {
  return `Hello, ${name}`;
}
```

### Arrow functions 

Arrow functions work exactly the same way as regular functions, just with different syntax. You will see these **everywhere** in modern TypeScript codebases, especially in React, callbacks, and array methods.

```
// Full syntax with curly braces and explicit return
const multiply = (x: number, y: number): number => {
  return x * y;
};

// Short syntax: Implicit return (no curly braces, no return keyword)
const divide = (x: number, y: number): number => x / y;

// Common real-world example: Array methods
const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map((num: number): number => num * 2);

// Callback in an event handler
const handleClick = (event: MouseEvent): void => {
  console.log("Button clicked!");
};
```
### Function Type Signatures

Sometimes you need to define the shape of a function itself, not just call it. This is common when passing functions as arguments or storing them in variables.

```
// Define what a function MUST look like
type MathOperation = (a: number, b: number) => number;

// Any function assigned to this type MUST accept two numbers and return a number
const subtract: MathOperation = (a, b) => a - b;
const add: MathOperation = (a, b) => a + b;

// TypeScript knows 'a' and 'b' are numbers automatically because of the type signature
```


### Optional and Defalt parameters

Not every function needs every argument every time. TypeScript gives you two tools to handle this.

#### Optional Parameters (`?`) 

Place a `?` after the parameter name. If the caller doesn't provide it, the value will be `undefined`. Optional parameters **must** come after required parameters.

```
function welcomeUser(name: string, age?: number): string {
    return `Welcome ${name}, you are ${age} years old.`;
}

welcomeUser("Alice");       // OK: age is undefined
welcomeUser("Alice", 28);   // OK: age is 28
```


#### Default Parameters 

Assign a fallback value using `=`. If the caller doesn't provide the argument, the default value is used instead of `undefined`. When you provide a default value, TypeScript automatically infers the type.


```
function sendEmail(to: string, subject: string = "No Subject"): void {
  console.log(`Sending to ${to} with subject: ${subject}`);
}

sendEmail("alice@example.com");                  // subject = "No Subject"
sendEmail("alice@example.com", "Meeting Notes"); // subject = "Meeting Notes"
```

### The `void` and `never` Returns Types 

These two return types describe functions that **don't give you useful data back**, but for very different reasons.

`void`: The function runs, does its job, but returns nothing meaningful. You will see this on functions that log to the console, update the DOM, or trigger side effects.

```
function logMessage(message: string): void {
  console.log(message);
  // No return statement needed (or you can write 'return;' with no value)
}
```


`never`: The function **never reaches its end**. It either throws an error or runs an infinite loop. You will mostly see this in error-handling functions or exhaustive switch statements.

```
// Throws an error and stops execution — never returns
function throwError(message: string): never {
  throw new Error(message);
}

// Infinite loop — never returns
function infiniteLoop(): never {
  while (true) {
    // do something forever
  }
}

// Common real-world use: Exhaustive checks in switch statements
type Shape = "circle" | "square";

function handleShape(shape: Shape): void {
  switch (shape) {
    case "circle":
      console.log("Drawing a circle");
      break;
    case "square":
      console.log("Drawing a square");
      break;
    default:
      // If someone adds a new shape to the type but forgets to handle it here,
      // TypeScript will throw a compile-time error. This is a safety net.
      const exhaustiveCheck: never = shape;
      throw new Error(`Unhandled shape: ${exhaustiveCheck}`);
  }
}
```


## Define Custom Shapes

When you work in a real codebase, you rarely just use `string` or `number`. You are dealing with complex data structures like Users, Products, or API Responses. TypeScript gives you two primary tools to define the "shape" of these objects: `interface` and `type`.

### The `interface` Keyword

An `interface` is specifically designed to describe the shape of an **object**. It acts as a contract: any object that claims to be this interface must have the exact properties defined, with the correct types.

**Key Modifiers you will see inside interfaces** .
- `?`**(Optional)**: The property might not exist.
- `readonly`: The property can be set once (usually at creation) but cannot be changed afterward.

```
interface User {
  id: number;               // Required property
  username: string;         // Required property
  email?: string;           // Optional property (can be undefined)
  readonly createdAt: Date; // Read-only property (cannot be modified)
  
  // You can also define method signatures inside an interface
  login(password: string): boolean; 
}

// Valid User object
const alice: User = {
  id: 1,
  username: "alice_dev",
  createdAt: new Date(),
  login: (pwd) => pwd === "secret"
};

// alice.createdAt = new Date(); // ERROR! Cannot assign to 'createdAt' because it is a read-only property.
```


### The `type` Alias 

While `interface` is strictly for objects, a `type` alias is much more flexible. It creates a custom name for any type, including primitives, unions, tuples, and objects.

Think of `type` as creating a new variable, but the value it holds is a TypeScript type.

```
// 1. Typing an object (Very similar to interface)
type Product = {
  id: string;
  price: number;
  inStock: boolean;
};

// 2. Typing a Union (Things interface CANNOT do)
type Status = "pending" | "processing" | "shipped" | "delivered";
let orderStatus: Status = "pending";

// 3. Typing a Primitive alias
type ID = string | number;
let userId: ID = 101;
let orderId: ID = "ORD-99";

// 4. Typing a Tuple (Fixed length array with specific types)
type Coordinate = [number, number];
let location: Coordinate = [40.7128, -74.0060];
```
### `interface` vs `type`: When to use which

This is a common debate, but for a team environment, it is best to establish a clear convention so everyone writes consistent code.

**The Golden Rule for Teams:**
- Use `interface` when defining the shape of an **object** (especially if it represents a core entity like a User, Product, or Database Record).
- Use `type` for everything else: Unions (`|`), primitives, tuples, and complex utility combinations.

**Why?**

1. **Error Messages**: TypeScript generally provides cleaner, easier-to-read error messages when you use `interface` for objects.
2. **Extensibility**: Interfaces can be "extended" or merged (see below), which is useful if you are building a library or want to allow other parts of the app to add properties to an object later. Types cannot be merged.

### Extending interface and intersecting type 

As your app grows, you will notice objects sharing common properties (e.g., both a `User` and an `Admin` have an `id` and `name`). Instead of duplicating code, you can extend or intersect them.

#### Extending Interfaces (`extends`)
Used to create a new interface that copies all properties from an existing one, and adds new ones. This is the standard Object-Oriented approach.

```
interface BaseEntity {
  id: string;
  createdAt: Date;
  updatedAt: Date;
}

// Employee inherits id, createdAt, and updatedAt from BaseEntity
interface Employee extends BaseEntity {
  employeeId: number;
  department: string;
}

const dev: Employee = {
  id: "uuid-123",
  createdAt: new Date(),
  updatedAt: new Date(),
  employeeId: 42,
  department: "Engineering"
};
```

#### Intersecting Types (`&`)

Used to merge multiple `type` aliases (or interfaces) into a single, combined type. The `&` symbol means *AND* (the resulting object must have properties from all intersected types).

```
type HasTimestamps = {
  createdAt: Date;
  updatedAt: Date;
};

type HasAuthor = {
  authorId: string;
};

// Article must have all properties from HasTimestamps AND HasAuthor, plus its own
type Article = {
  title: string;
  content: string;
} & HasTimestamps & HasAuthor;

// Alternatively, written inline:
type Post = { title: string } & { views: number };
```

## Handling Flexibilty

In the real world, data isn't always perfectly predictable. Sometimes a value can be a string or a number, sometimes an object property might be missing, and sometimes you want to restrict a variable to a very specific set of words. TypeScript provides elegant ways to handle all of this.

### Union Types (`|`)

A Union type allows a value to be one of several types. You use the pipe symbol (`|`) to separate the allowed types. Think of it as an "OR" operator for types.

This is incredibly common when dealing with data that might change shape, like API responses or form inputs.

```
// A variable that can be EITHER a string OR a number
let userId: string | number;

userId = 101;     // OK
userId = "101";   // OK
// userId = true; // ERROR! 'boolean' is not allowed.

// Real-world example: Handling API responses
interface User { name: string; }
interface ApiError { message: string; code: number; }

// The response will be EITHER a successful User OR an Error object
type ApiResponse = User | ApiError;

function handleResponse(response: ApiResponse) {
  // Note: You can't just access 'response.name' here, 
  // because TS doesn't know if it's a User or an ApiError yet!
  // You have to check it first (covered in Section 8: Type Narrowing).
}
```



### Optional Properties (`?`)

When defining the shape of an object (using `interface` or `type`), you can mark specific properties as optional by adding a question mark (`?`) after the property name.
This tells TypeScript: "This property might exist, or it might be completely missing from the object."


```
interface UserProfile {
  username: string;
  email: string;
  bio?: string;       // Optional: might be missing
  age?: number;       // Optional: might be missing
}

const user1: UserProfile = {
  username: "alice",
  email: "alice@example.com"
  // bio and age are omitted. This is perfectly valid.
};

const user2: UserProfile = {
  username: "bob",
  email: "bob@example.com",
  bio: "Hello world!",
  age: 25
};

// Note: Optional properties are different from 'null'.
// If a property is optional (bio?), it can be 'string' or 'undefined'.
// If you want it to explicitly hold 'null', you must write: bio: string | null;
```

### Literal Types (Restricting to exact values)

So far, we've used types like `string` or `number`, which represent a massive range of possible values. A **Literal Type** restricts a variable to one **exact, specific value**.

Literal types are almost always combined with Union Types (`|`) to create a strict list of allowed options. This is a modern, highly preferred alternative to using `enum` or random strings/numbers in your code.

```
// 1. String Literal Types
// Instead of just 'string', it MUST be exactly one of these three words.
type Theme = "light" | "dark" | "system";

let currentTheme: Theme = "dark"; // OK
// currentTheme = "blue";         // ERROR! "blue" is not a valid Theme.

// 2. Number Literal Types
type DiceRoll = 1 | 2 | 3 | 4 | 5 | 6;
let roll: DiceRoll = 4; // OK
// roll = 7;            // ERROR!

// 3. Boolean Literal Types (Rare, but possible)
type TrueOnly = true; 
let isReady: TrueOnly = true; // OK
// isReady = false;           // ERROR!

// WHY THIS IS POWERFUL:
// Instead of passing random strings like "pending", "success", "failed" 
// into a function and risking typos, you force the caller to use exact literals.

type RequestStatus = "idle" | "loading" | "success" | "error";

function updateUI(status: RequestStatus) {
  // Implementation...
}

updateUI("loading"); // OK
// updateUI("lodding"); // ERROR! Typo caught at compile time.
```

## Generics

### What are Generics? (Variables for Types)
Think of generics as **variables, but for types**.
When you write a regular function, you use parameters (variables) so the function can work with different values:

```
function echo(value: string): string {
  return value;
}
```

But what if you want a function to work with different types? You could use `any`, but that defeats the purpose of TypeScript. Generics let you write code that works with **any type, while still maintaining type safety**.


The syntax uses angle brackets `< >` with a type parameter (conventionally named `T`, but can be anything like `TValue`, `TResult`, etc.):

```
// T is a placeholder for whatever type the caller provides
function echo<T>(value: T): T {
  return value;
}

const strResult = echo("hello");     // T becomes 'string'
const numResult = echo(42);          // T becomes 'number'
const boolResult = echo(true);       // T becomes 'boolean'
```


**Why not just use `any`?**
```
// BAD: Using 'any' loses type information
function echoBad(value: any): any {
  return value;
}
const result = echoBad("hello"); // TypeScript thinks 'result' is 'any'
result.toUpperCase(); // No error, but what if result was actually a number?

// GOOD: Using generics preserves type information
function echoGood<T>(value: T): T {
  return value;
}
const result2 = echoGood("hello"); // TypeScript knows 'result2' is 'string'
result2.toUpperCase(); // Works perfectly, with full autocomplete
```

### Generic Function 

Generic functions allow you to write reusable logic that works with multiple types while keeping type safety.

#### Basic Generic Function 

```
// Returns the first item of any array
function getFirst<T>(items: T[]): T {
  return items[0];
}

const firstNumber = getFirst([1, 2, 3]);       // Type: number
const firstString = getFirst(["a", "b", "c"]); // Type: string
const firstUser = getFirst([{ name: "Alice" }]); // Type: { name: string }
```

#### Multiple Type Parameters 
You can use multiple type parameters when a function needs to work with more than one type:
```
// Creates a key-value pair
function createPair<K, V>(key: K, value: V): [K, V] {
  return [key, value];
}

const pair1 = createPair("age", 25);           // Type: [string, number]
const pair2 = createPair(1, true);             // Type: [number, boolean]
const pair3 = createPair("user", { name: "Bob" }); // Type: [string, { name: string }]
```

#### Constraining Generics

Sometimes you want to restrict what types can be used. Use the extends keyword to constrain generics:
```
// T must have a 'length' property (strings, arrays, etc.)
function logLength<T extends { length: number }>(item: T): void {
  console.log(`Length: ${item.length}`);
}

logLength("hello");     // OK: strings have .length
logLength([1, 2, 3]);   // OK: arrays have .length
// logLength(42);       // ERROR: numbers don't have .length
```

### Generic Interface and Classes 

Generics aren't limited to functions. You can use them in interfaces and classes to create reusable, type-safe structures.

#### Generic Interfaces 

```
// A box that can hold any type of content
interface Box<T> {
  content: T;
  label: string;
  open(): T;
}

const stringBox: Box<string> = {
  content: "Hello",
  label: "Greeting Box",
  open: () => "Hello"
};

const numberBox: Box<number> = {
  content: 42,
  label: "Number Box",
  open: () => 42
};

// Generic interface with multiple type parameters
interface KeyValuePair<K, V> {
  key: K;
  value: V;
}

const ageEntry: KeyValuePair<string, number> = {
  key: "age",
  value: 25
};
```


#### Generic Classes 

Classes can also be generic, allowing you to create reusable components that work with different data types.

```
class Stack<T> {
  private items: T[] = [];

  push(item: T): void {
    this.items.push(item);
  }

  pop(): T | undefined {
    return this.items.pop();
  }

  peek(): T | undefined {
    return this.items[this.items.length - 1];
  }

  isEmpty(): boolean {
    return this.items.length === 0;
  }
}

// Create a stack of numbers
const numberStack = new Stack<number>();
numberStack.push(1);
numberStack.push(2);
const topNumber = numberStack.pop(); // Type: number | undefined

// Create a stack of strings
const stringStack = new Stack<string>();
stringStack.push("hello");
stringStack.push("world");
const topString = stringStack.pop(); // Type: string | undefined
```

#### Generic Classes with Constraints


```
// T must have an 'id' property
class Repository<T extends { id: string }> {
  private items: T[] = [];

  add(item: T): void {
    this.items.push(item);
  }

  findById(id: string): T | undefined {
    return this.items.find(item => item.id === id);
  }

  getAll(): T[] {
    return this.items;
  }
}

interface User {
  id: string;
  name: string;
  email: string;
}

const userRepo = new Repository<User>();
userRepo.add({ id: "1", name: "Alice", email: "alice@example.com" });
const user = userRepo.findById("1"); // Type: User | undefined
if (user) {
  console.log(user.name); // Full autocomplete works!
}
```

#### Common Built-in Generic Types You'll See 

TypeScript provides several built-in generic types that you'll encounter constantly:

```
// Promise<T> - A promise that resolves to type T
async function getUser(): Promise<User> {
  return { id: "1", name: "Alice" };
}

// Array<T> - Same as T[], just different syntax
const numbers: Array<number> = [1, 2, 3];

// Map<K, V> - A dictionary with keys of type K and values of type V
const userMap: Map<string, User> = new Map();
userMap.set("1", { id: "1", name: "Alice" });

// Set<T> - A collection of unique values of type T
const uniqueIds: Set<string> = new Set(["1", "2", "3"]);
```

## Built-in Utility Types 


### `Parial<T>`: Making things optional 

### `Required<T>`: Making things mandatory

### `Pick<T,K>` and `Omit<T,K>`: Selecting or removing properties 

### `Record<K,T>`: Creating dicitionaries/maps


## Type Narrowing and Guards

### What is Type Narrowing.

### Checking tyes with `typeof`, `in` and `instanceof`

### Discriminated Unions 

## Object-Oriented (Classes)

### Class Basics and Typing Properties 

### Access Modifiers (`public`, `private`, `protected`)

### Implement Interface (`implements`)


## Escaping Hatches & Assertions

### Type Assertions / Casting (`as`)

### The Non-Null Assertion Operator (`!`)

### The `any` type vs the `unknow` type (and why we avoid `any`)

## Team Conventions & Best Practices

