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

```typescript
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

```typescript
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


### Type Inference vs Explicity Annotation 

TypeScript is smart. You don't always have to write the type yourself.

- **Explicit Annotation**: You manually write the type (e.g., `let x: number = 5`). Use this when declaring variables without initializing them immediately, or when you need to restrict a variable to a specific subset of values.
- **Implicit Inference** : TypeScript guesses the type based on the value you assign. This keeps your code clean and readable.

```typescript
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

```typescript
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
```typescript
// Syntax: function name(param: type, param: type): returnType {}

function add(a: number, b: number): number {
  return a + b;
}

add(5, 10);    // OK
// add(5, "10"); // ERROR! Argument of type 'string' is not assignable to 'number'.
```

If you forget the return type, TypeScript will infer it from what you return. However, explicitly writing it is considered a best practice in teams because it acts as documentation and catches bugs if you accidentally return the wrong thing.

```typescript
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

```typescript
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

```typescript
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

```typescript
function welcomeUser(name: string, age?: number): string {
    return `Welcome ${name}, you are ${age} years old.`;
}

welcomeUser("Alice");       // OK: age is undefined
welcomeUser("Alice", 28);   // OK: age is 28
```


#### Default Parameters 

Assign a fallback value using `=`. If the caller doesn't provide the argument, the default value is used instead of `undefined`. When you provide a default value, TypeScript automatically infers the type.


```typescript
function sendEmail(to: string, subject: string = "No Subject"): void {
  console.log(`Sending to ${to} with subject: ${subject}`);
}

sendEmail("alice@example.com");                  // subject = "No Subject"
sendEmail("alice@example.com", "Meeting Notes"); // subject = "Meeting Notes"
```

### The `void` and `never` Returns Types 

These two return types describe functions that **don't give you useful data back**, but for very different reasons.

`void`: The function runs, does its job, but returns nothing meaningful. You will see this on functions that log to the console, update the DOM, or trigger side effects.

```typescript
function logMessage(message: string): void {
  console.log(message);
  // No return statement needed (or you can write 'return;' with no value)
}
```


`never`: The function **never reaches its end**. It either throws an error or runs an infinite loop. You will mostly see this in error-handling functions or exhaustive switch statements.

```typescript
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

```typescript
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

```typescript
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

```typescript
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

```typescript
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

```typescript
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


```typescript
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

```typescript
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

```typescript
function echo(value: string): string {
  return value;
}
```

But what if you want a function to work with different types? You could use `any`, but that defeats the purpose of TypeScript. Generics let you write code that works with **any type, while still maintaining type safety**.


The syntax uses angle brackets `< >` with a type parameter (conventionally named `T`, but can be anything like `TValue`, `TResult`, etc.):

```typescript
// T is a placeholder for whatever type the caller provides
function echo<T>(value: T): T {
  return value;
}

const strResult = echo("hello");     // T becomes 'string'
const numResult = echo(42);          // T becomes 'number'
const boolResult = echo(true);       // T becomes 'boolean'
```


**Why not just use `any`?**
```typescript
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

```typescript
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
```typescript
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
```typescript
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

```typescript
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

```typescript
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


```typescript
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

```typescript
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

TypeScript provides a set of built-in utility types that let you transform existing types into new ones without rewriting them from scratch. These are used constantly in real codebases to avoid duplication and keep your types DRY (Don't Repeat Yourself).



### `Parial<T>`: Making things optional 

`Partial<T>` takes an existing type and makes all of its properties optional. This is incredibly useful when you want to update an object but don't want to require every single property.

**Without Partial (The Problem)**:
```typescript
interface User {
  id: string;
  name: string;
  email: string;
  age: number;
}

// If we want to update just the email, we'd have to provide ALL properties
function updateUser(user: User, updates: User): User {
  return { ...user, ...updates };
}

// This is annoying - we have to pass everything even if we're only changing one thing
updateUser(
  { id: "1", name: "Alice", email: "alice@example.com", age: 25 },
  { id: "1", name: "Alice", email: "newemail@example.com", age: 25 } // Had to repeat everything!
);
```

**With Partial (The Solution)**:

```typescript
interface User {
  id: string;
  name: string;
  email: string;
  age: number;
}

// Now updates can have ANY subset of User properties
function updateUser(user: User, updates: Partial<User>): User {
  return { ...user, ...updates };
}

// Much better - only pass what you want to change
updateUser(
  { id: "1", name: "Alice", email: "alice@example.com", age: 25 },
  { email: "newemail@example.com" } // Only updating email!
);

updateUser(
  { id: "1", name: "Alice", email: "alice@example.com", age: 25 },
  { name: "Alice Smith", age: 26 } // Updating name and age
);
```

**Common use cases:**:

- Update/Patch API endpoints.
- Form data where not all fields are filled.
- Configuration objects with optional overrides.

### `Required<T>`: Making things mandatory

`Required<T>` does the opposite of `Partial`—it takes a type with optional properties and makes **all of them required**. This is useful when you have a configuration object where some properties are optional during input, but you want to ensure they all exist after processing

```typescript
interface UserSettings {
  theme?: "light" | "dark";
  notifications?: boolean;
  language?: string;
}

// During input, all properties are optional
function getUserInput(): UserSettings {
  return { theme: "dark" }; // Only theme is provided
}

// After processing, we want to ensure ALL settings exist with defaults
type CompleteUserSettings = Required<UserSettings>;

function applyDefaults(settings: UserSettings): CompleteUserSettings {
  return {
    theme: settings.theme || "light",
    notifications: settings.notifications || true,
    language: settings.language || "en"
  };
}

const input = getUserInput();
const complete = applyDefaults(input);

// Now TypeScript knows ALL properties exist
console.log(complete.theme);         // Type: "light" | "dark" (not optional!)
console.log(complete.notifications); // Type: boolean (not optional!)
console.log(complete.language);      // Type: string (not optional!)
```
**Common use cases:**:

- Configuration objects after applying defaults.
- Database records where optional fields become required after creation.
- Form validation where all fields must be present before submission.

### `Pick<T,K>` and `Omit<T,K>`: Selecting or removing properties 

These two utility types let you create new types by selecting or excluding specific properties from an existing type.

**`Pick<T, K>`: Keep only specified properties.**
`Pick<T, K>` creates a new type by picking only the properties `K` from type `T`.

```typescript
interface User {
  id: string;
  name: string;
  email: string;
  password: string;
  createdAt: Date;
  updatedAt: Date;
}

// Create a type with only id and name
type UserSummary = Pick<User, "id" | "name">;

const summary: UserSummary = {
  id: "1",
  name: "Alice"
  // email, password, etc. are NOT allowed here
};

// Common use case: API responses where you don't want to expose sensitive data
function getUserProfile(userId: string): UserSummary {
  const user = database.findById(userId);
  return {
    id: user.id,
    name: user.name
    // We intentionally don't return password, email, etc.
  };
}
```



`Omit<T, K>` creates a new type by omitting (removing) the properties `K` from type `T`. This is the opposite of `Pick`.

```typescript
interface User {
  id: string;
  name: string;
  email: string;
  password: string;
  createdAt: Date;
  updatedAt: Date;
}

// Create a type without password (for public APIs)
type PublicUser = Omit<User, "password">;

const publicUser: PublicUser = {
  id: "1",
  name: "Alice",
  email: "alice@example.com",
  createdAt: new Date(),
  updatedAt: new Date()
  // password is NOT allowed here
};

// Remove multiple properties
type CreateUserInput = Omit<User, "id" | "createdAt" | "updatedAt">;

const newUser: CreateUserInput = {
  name: "Bob",
  email: "bob@example.com",
  password: "secret123"
  // id, createdAt, updatedAt are NOT allowed (they'll be generated by the server)
};
```

**Pick vs Omit - When to use which:**

- Use `Pick` when you want to keep only a few properties from a large type.
- Use `Omit` when you want to remove just a few properties from a large type.
- If you're keeping more than you're removing, use `Pick`.
- If you're removing more than you're keeping, use `Omit`.

### `Record<K,T>`: Creating dicitionaries/maps

`Record<K, T>` creates a type for an object where:

- `K` is the type of the keys.
- `T` is the type of the values.

This is the TypeScript way to type dictionaries, maps, or key-value stores.

```typescript
// A dictionary where keys are strings and values are numbers
type Inventory = Record<string, number>;

const inventory: Inventory = {
  apples: 5,
  bananas: 10,
  oranges: 3
};

inventory.apples = 4; // OK
// inventory.unknown = 5; // ERROR: Property 'unknown' doesn't exist

// A dictionary where keys are specific strings (literal types)
type UserRole = "admin" | "user" | "guest";
type Permissions = Record<UserRole, string[]>;

const permissions: Permissions = {
  admin: ["read", "write", "delete"],
  user: ["read", "write"],
  guest: ["read"]
  // All keys MUST be present because we specified the exact union type
};
```

## Type Narrowing and Guards

When you work with Union types (values that can be multiple types), TypeScript doesn't always know which specific type you're dealing with at any given moment. Type narrowing is how you tell TypeScript: "At this point in the code, I know exactly what type this is."

### What is Type Narrowing.
Type narrowing is the process of refining a variable's type from a broader type (like `string` | `number`) to a more specific type (like just `string`) within a specific block of code.

**The Problem**:
```typescript
function printLength(value: string | number) {
  // ERROR: Property 'length' does not exist on type 'string | number'
  console.log(value.length); 
  
  // ERROR: Property 'toFixed' does not exist on type 'string | number'
  console.log(value.toFixed(2));
}
```
TypeScript is saying: "I know `value` is either a string or a number, but I don't know which one it is right now. I can't let you call methods that only exist on one of them."


**The Solution - Type Narrowing**:
```typescript
function printLength(value: string | number) {
  if (typeof value === "string") {
    // TypeScript NOW knows value is a string
    console.log(value.toUpperCase()); // Works!
    console.log(value.length);        // Works!
  } else {
    // TypeScript NOW knows value is a number
    console.log(value.toFixed(2));    // Works!
    console.log(value * 2);           // Works!
  }
}
```
Inside the `if` block, TypeScript has "narrowed" the type from `string` | `number` to just `string`. Inside the `else` block, it's narrowed to just `number`.


**Why this matters**:

- Prevents runtime errors by catching type mismatches at compile time.
- Enables autocomplete for the specific type.
- Makes your code's intent clear to other developers.


### Checking tyes with `typeof`, `in` and `instanceof`

TypeScript recognizes several patterns that narrow types. These are called "type guards."


**`typeof` - For primitive types**

Use `typeof` to check the type of primitive values (string, number, boolean, etc.).


```typescript
function processValue(value: string | number | boolean) {
  if (typeof value === "string") {
    // value is narrowed to 'string'
    console.log(value.toUpperCase());
  } else if (typeof value === "number") {
    // value is narrowed to 'number'
    console.log(value.toFixed(2));
  } else {
    // value is narrowed to 'boolean'
    console.log(value ? "Yes" : "No");
  }
}

// Common typeof values:
// "string", "number", "boolean", "undefined", "object", "function", "bigint", "symbol"
```

**Important limitation**: `typeof` can't distinguish between different object types. Both arrays and objects return `"object"`.

```typescript
function handleData(data: string[] | { name: string }) {
  // BAD: This doesn't work - both return "object"
  if (typeof data === "object") {
    // TypeScript still doesn't know if it's an array or object
  }
  
  // GOOD: Use Array.isArray() instead
  if (Array.isArray(data)) {
    // TypeScript knows data is string[]
    console.log(data[0].toUpperCase());
  } else {
    // TypeScript knows data is { name: string }
    console.log(data.name);
  }
}
```

**`in` - For checking object properties**

Use the `in` operator to check if a property exists on an object. This is perfect for narrowing union types of objects.

```typescript
interface Fish {
  swim: () => void;
  name: string;
}

interface Bird {
  fly: () => void;
  name: string;
}

function move(animal: Fish | Bird) {
  if ("swim" in animal) {
    // TypeScript knows animal is a Fish
    animal.swim();
  } else {
    // TypeScript knows animal is a Bird
    animal.fly();
  }
}

// Real-world example: API responses
interface SuccessResponse {
  status: "success";
  data: User;
}

interface ErrorResponse {
  status: "error";
  message: string;
}

function handleResponse(response: SuccessResponse | ErrorResponse) {
  if ("data" in response) {
    // TypeScript knows response is SuccessResponse
    console.log(response.data.name);
  } else {
    // TypeScript knows response is ErrorResponse
    console.log(response.message);
  }
}
```


**`instanceof` - For class instances**

Use `instanceof` to check if an object is an instance of a specific class. This is common when working with custom classes or built-in classes like `Date` or `Error`.

```typescript
class Dog {
  bark() {
    console.log("Woof!");
  }
}

class Cat {
  meow() {
    console.log("Meow!");
  }
}

function makeSound(animal: Dog | Cat) {
  if (animal instanceof Dog) {
    // TypeScript knows animal is a Dog
    animal.bark();
  } else {
    // TypeScript knows animal is a Cat
    animal.meow();
  }
}

// Real-world example: Error handling
function handleError(error: Error | TypeError | RangeError) {
  if (error instanceof TypeError) {
    console.log("Type error:", error.message);
  } else if (error instanceof RangeError) {
    console.log("Range error:", error.message);
  } else {
    console.log("Generic error:", error.message);
  }
}

// Checking for Date objects
function formatDate(value: string | Date) {
  if (value instanceof Date) {
    // TypeScript knows value is a Date
    return value.toISOString();
  } else {
    // TypeScript knows value is a string
    return new Date(value).toISOString();
  }
}
```

**Truthiness narrowing**

TypeScript also narrows types based on truthiness checks (checking if a value is truthy or falsy).

```typescript
function printMessage(message: string | null | undefined) {
  if (message) {
    // TypeScript knows message is a non-empty string
    console.log(message.toUpperCase());
  } else {
    // TypeScript knows message is null or undefined
    console.log("No message provided");
  }
}

// Be careful with this - it also treats 0, "", and false as falsy
function printNumber(value: number | null) {
  if (value) {
    // This excludes 0!
    console.log(value.toFixed(2));
  }
  
  // Better approach for numbers
  if (value !== null) {
    console.log(value.toFixed(2)); // Includes 0
  }
}
```

### Discriminated Unions 

Discriminated unions (also called "tagged unions" or "algebraic data types") are a powerful pattern for working with union types. They use a common property (the "discriminant") that has a literal type, which TypeScript uses to narrow the union.


**The Pattern:**:

1. All types in the union share a common property with a literal type.
2. Each type has a different value for that property.
3. You check that property to narrow the type.

**Basic Example**:

```typescript
// All shapes have a 'kind' property with a literal type
type Shape =
  | { kind: "circle"; radius: number }
  | { kind: "square"; sideLength: number }
  | { kind: "rectangle"; width: number; height: number };

function getArea(shape: Shape): number {
  switch (shape.kind) {
    case "circle":
      // TypeScript knows shape is { kind: "circle"; radius: number }
      return Math.PI * shape.radius ** 2;
    
    case "square":
      // TypeScript knows shape is { kind: "square"; sideLength: number }
      return shape.sideLength ** 2;
    
    case "rectangle":
      // TypeScript knows shape is { kind: "rectangle"; width: number; height: number }
      return shape.width * shape.height;
  }
}

// Usage
const circle: Shape = { kind: "circle", radius: 5 };
const square: Shape = { kind: "square", sideLength: 4 };

console.log(getArea(circle)); // 78.54...
console.log(getArea(square)); // 16
```

**Exhaustiveness Checking**

One of the most powerful features of discriminated unions is that TypeScript can tell you if you forgot to handle a case.

```typescript
type Shape =
  | { kind: "circle"; radius: number }
  | { kind: "square"; sideLength: number };

function getArea(shape: Shape): number {
  switch (shape.kind) {
    case "circle":
      return Math.PI * shape.radius ** 2;
    case "square":
      return shape.sideLength ** 2;
    default:
      // If someone adds a new shape to the union but forgets to handle it here,
      // TypeScript will throw an error on this line
      const _exhaustiveCheck: never = shape;
      return _exhaustiveCheck;
  }
}

// Later, someone adds a new shape:
type Shape =
  | { kind: "circle"; radius: number }
  | { kind: "square"; sideLength: number }
  | { kind: "triangle"; base: number; height: number }; // NEW!

// Now TypeScript will error in getArea because we didn't handle "triangle"
// This prevents bugs at compile time!
```

## Object-Oriented (Classes)

TypeScript adds strong typing to JavaScript classes. While modern JavaScript has classes, TypeScript lets you enforce types on properties, methods, and control access to them. You'll see classes used frequently for services, data models, and complex state management.

### Class Basics and Typing Properties 

In TypeScript, you must declare the type of every class property. Unlike JavaScript where you can just assign values in the constructor, TypeScript requires you to define the shape upfront.

#### Basic Class Structure

```typescript
class User {
  // Property declarations with types
  id: number;
  name: string;
  email: string;
  
  // Constructor - parameters must be typed
  constructor(id: number, name: string, email: string) {
    this.id = id;
    this.name = name;
    this.email = email;
  }
  
  // Methods with typed parameters and return types
  greet(): string {
    return `Hello, I'm ${this.name}`;
  }
  
  updateEmail(newEmail: string): void {
    this.email = newEmail;
  }
}

const user = new User(1, "Alice", "alice@example.com");
console.log(user.greet()); // "Hello, I'm Alice"
```

#### Readonly Properties 
Use `readonly` to prevent properties from being changed after initialization. This is great for IDs, timestamps, or any value that shouldn't be mutated.


```typescript
class Product {
  readonly id: string;
  name: string;
  price: number;
  readonly createdAt: Date;
  
  constructor(id: string, name: string, price: number) {
    this.id = id;
    this.name = name;
    this.price = price;
    this.createdAt = new Date();
  }
}

const product = new Product("p-123", "Laptop", 999);
// product.id = "p-456"; // ERROR! Cannot assign to 'id' because it is a read-only property.
product.name = "Gaming Laptop"; // OK - name is not readonly
```

#### Property Initialization 

If you don't initialize a property in the constructor, TypeScript will complain. You have a few options
```typescript
class Config {
  // Option 1: Initialize with a default value
  timeout: number = 5000;
  
  // Option 2: Make it optional
  apiKey?: string;
  
  // Option 3: Use definite assignment assertion (!)
  // Use this when you KNOW it will be set before use (e.g., in an init method)
  database!: string;
  
  init() {
    this.database = "postgres://localhost";
  }
}
```

#### Static Properties and Methods 

Static members belong to the class itself, not to instances. They're accessed via the class name.
```typescript
class MathUtils {
  static PI = 3.14159;
  
  static circleArea(radius: number): number {
    return MathUtils.PI * radius * radius;
  }
}

console.log(MathUtils.PI); // 3.14159
console.log(MathUtils.circleArea(5)); // 78.53975
```

#### Constructor Parameter Shorthand
TypeScript provides a convenient shorthand for declaring and initializing properties in the constructor. This is **extremely common** in real codebases.

```typescript
// WITHOUT shorthand (verbose)
class User {
  public id: number;
  private password: string;
  protected role: string;
  
  constructor(id: number, password: string, role: string) {
    this.id = id;
    this.password = password;
    this.role = role;
  }
}

// WITH shorthand (clean and concise)
class User {
  constructor(
    public id: number,
    private password: string,
    protected role: string
  ) {
    // Properties are automatically declared and initialized
  }
}

// Both versions do exactly the same thing!
const user = new User(1, "secret", "admin");
```


### Access Modifiers (`public`, `private`, `protected`)
TypeScript provides three access modifiers to control visibility of class members. This is crucial for encapsulation—hiding internal implementation details and exposing only what's necessary.

#### `public` (Default)

Members are accessible from anywhere. If you don't specify a modifier, it's `public` by default.

```typescript
class User {
  public name: string; // Explicitly public
  email: string;       // Implicitly public (same thing)
  
  constructor(name: string, email: string) {
    this.name = name;
    this.email = email;
  }
}

const user = new User("Alice", "alice@example.com");
console.log(user.name);  // OK - public
console.log(user.email); // OK - public
```

#### private

Members are accessible only **within the class itself**. Not even subclasses can access them. This is perfect for internal state that shouldn't be modified directly.

```typescript
class BankAccount {
  private balance: number;
  public owner: string;
  
  constructor(owner: string, initialBalance: number) {
    this.owner = owner;
    this.balance = initialBalance;
  }
  
  // Public method to safely modify private state
  deposit(amount: number): void {
    if (amount > 0) {
      this.balance += amount; // OK - accessing private from within the class
    }
  }
  
  // Public method to read private state
  getBalance(): number {
    return this.balance;
  }
}

const account = new BankAccount("Alice", 1000);
account.deposit(500);
console.log(account.getBalance()); // 1500
// console.log(account.balance);   // ERROR! Property 'balance' is private
```

#### protected

Members are accessible within the class and its subclasses, but not from outside. This is useful when you want subclasses to have access to certain properties/methods but keep them hidden from the rest of the codebase.

```typescript
class Animal {
  protected name: string;
  
  constructor(name: string) {
    this.name = name;
  }
  
  protected makeSound(): void {
    console.log("Some generic animal sound");
  }
}

class Dog extends Animal {
  bark(): void {
    console.log(`${this.name} says: Woof!`); // OK - can access protected 'name'
    this.makeSound(); // OK - can call protected method
  }
}

const dog = new Dog("Rex");
dog.bark(); // "Rex says: Woof!"
// console.log(dog.name); // ERROR! Property 'name' is protected
// dog.makeSound();       // ERROR! Method 'makeSound' is protected
```


**Access Modifier Summary**
|Modifier   |Class      |Subclass   |Outside    |
|-----------|-----------|-----------|-----------|
|`public`   |✔          |✔          |✔          |
|`protected`|✔          |✔          |𐄂          |
|`private`  |✔          |𐄂          |𐄂          |


### Implement Interface (`implements`)

The `implements` keyword ensures that a class matches the shape defined by an interface. This is different from `extends` (which is for class inheritance).

#### Basic Implementation 

```typescript
// Define the contract
interface Logger {
  log(message: string): void;
  error(message: string): void;
}

// Class MUST implement all methods from the interface
class ConsoleLogger implements Logger {
  log(message: string): void {
    console.log(`[LOG] ${message}`);
  }
  
  error(message: string): void {
    console.error(`[ERROR] ${message}`);
  }
}

// ERROR: Class 'BadLogger' incorrectly implements interface 'Logger'
// Property 'error' is missing
class BadLogger implements Logger {
  log(message: string): void {
    console.log(message);
  }
  // Missing error() method!
}
```


#### Multiple Interface Implementation 

A class can implement multiple interfaces, separated by commas.

```typescript
interface Printable {
  print(): void;
}

interface Serializable {
  serialize(): string;
}

interface Loggable {
  log(): void;
}

class Document implements Printable, Serializable, Loggable {
  constructor(public content: string) {}
  
  print(): void {
    console.log(this.content);
  }
  
  serialize(): string {
    return JSON.stringify({ content: this.content });
  }
  
  log(): void {
    console.log(`Document: ${this.content}`);
  }
}
```

#### Extends vs Implements 

This is a common point of confusion. Here's the difference:

```typescript
// Interface extends Interface (adds more properties to the contract)
interface Vehicle {
  brand: string;
  start(): void;
}

interface ElectricVehicle extends Vehicle {
  batteryCapacity: number;
  charge(): void;
}

// Class extends Class (inherits implementation)
class BaseVehicle {
  start(): void {
    console.log("Starting vehicle...");
  }
}

class Car extends BaseVehicle {
  drive(): void {
    console.log("Driving...");
  }
}

// Class implements Interface (class must provide the implementation)
class Tesla implements ElectricVehicle {
  brand: string;
  batteryCapacity: number;
  
  constructor(brand: string, batteryCapacity: number) {
    this.brand = brand;
    this.batteryCapacity = batteryCapacity;
  }
  
  start(): void {
    console.log("Silent start...");
  }
  
  charge(): void {
    console.log("Charging...");
  }
}
```

#### Key Differences


|Feature                    | `extends`                             | `implements`              |
|---------------------------|---------------------------------------|---------------------------|
|Used with                  |Class → Class, Interface → Interface   |Class → Interface          |
|Purpose                    |Inherit implementation                 | Enforce a contract        |
|Can have multiple?         |No (single inheritance)                |Yes (multiple interfaces)  |
|Provides implementation?   |Yes                                    |No (just the shape)        |


#### Abstract Classes (Brief Mention)

Abstract classes are like a middle ground between interfaces and regular classes. They can have both implemented methods and abstract methods (that subclasses must implement).


```typescript
abstract class Shape {
  // Concrete method (has implementation)
  describe(): void {
    console.log(`I am a ${this.getName()}`);
  }
  
  // Abstract method (must be implemented by subclasses)
  abstract getName(): string;
  abstract getArea(): number;
}

class Circle extends Shape {
  constructor(private radius: number) {
    super();
  }
  
  getName(): string {
    return "Circle";
  }
  
  getArea(): number {
    return Math.PI * this.radius ** 2;
  }
}

const circle = new Circle(5);
circle.describe(); // "I am a Circle"
console.log(circle.getArea()); // 78.54...
```


## Escaping Hatches & Assertions

Sometimes TypeScript's strict type checking gets in the way, or you're working with external libraries and data that TypeScript can't fully understand. These "escape hatches" let you override TypeScript's type system when you know something the compiler doesn't. Use them sparingly and intentionally.

### Type Assertions / Casting (`as`)

Type assertions tell TypeScript: "Trust me, I know this value is actually this specific type." It's like casting in other languages, but it only affects compile-time checking—it doesn't actually transform the data at runtime


#### When to use `as`:

1. DOM Manipulation: When you know more about an element than TypeScript does.
2. Working with external data: When you're certain about the shape of data from an API.
3. Legacy code integration: When bridging typed and untyped code.


#### Basic Syntax

```typescript
// Using 'as' keyword (preferred)
const canvas = document.getElementById("my-canvas") as HTMLCanvasElement;
canvas.width = 500; // TypeScript now knows this is a canvas element

// Alternative syntax (less common, used in JSX/TSX files)
const canvas = <HTMLCanvasElement>document.getElementById("my-canvas");
```

#### Double Assertions (Casting through `unknown`):

Sometimes you need to cast to a completely unrelated type. TypeScript won't let you do this directly, but you can go through `unknown` first:


```typescript
const user = { name: "Alice" };

// ERROR: Conversion of type '{ name: string; }' to type 'string' 
// may be a mistake
const name = user as string;

// OK: Cast to unknown first, then to the target type
const name2 = user as unknown as string;

// WARNING: This is dangerous! The runtime value is still an object,
// but TypeScript thinks it's a string. Use with extreme caution.
```

**Type Assertions vs Type Guards**:

```typescript
// BAD: Using assertions when you should use type guards
function processData(data: unknown) {
  const str = data as string; // Dangerous! What if it's not a string?
  console.log(str.toUpperCase()); // Runtime error if data is a number
}

// GOOD: Using type guards to safely narrow
function processDataSafe(data: unknown) {
  if (typeof data === "string") {
    console.log(data.toUpperCase()); // Safe!
  }
}
```

#### Best Practices:

- Use `as` only when you have certainty about the type
- Prefer type guards (typeof, instanceof) when possible
- Avoid double assertions (as unknown as) unless absolutely necessary
- Document why you're using an assertion with a comment.


### The Non-Null Assertion Operator (`!`)
The non-null assertion operator (`!`) tells TypeScript: "I promise this value is NOT `null` or `undefined`, so stop complaining about it." It removes `null` and `undefined` from a type.



#### When to use !

1. **After checks**: When you've already verified the value exists.
2. **DOM queries**: When you're certain an element exists.
3. **Initialization patterns**: When a value is set before use but TypeScript can't track it.


#### Basic Syntax 

```typescript
let username: string | null = null;

// TypeScript error: Object is possibly 'null'
console.log(username.length);

// Non-null assertion: "I know it's not null"
username = "Alice";
console.log(username!.length); // OK: 5
```
#### Dangerous Usage (Avoid This)

```typescript
// BAD: Using ! without actually checking
function getUser(id: string): User | null {
  // This might return null!
  return database.findById(id);
}

const user = getUser("123")!; // DANGEROUS!
console.log(user.name); // Runtime error if user is null!

// GOOD: Check first, then use !
const user = getUser("123");
if (user) {
  console.log(user.name); // Safe
}

// OR: Use optional chaining
const name = getUser("123")?.name; // Safe, returns undefined if null
```

#### Non-Null Assertion in Class Properties 

```typescript
class UserService {
  // Use ! when you know the property will be initialized before use
  private database!: Database;
  
  init() {
    this.database = new Database();
  }
  
  getUser(id: string) {
    // TypeScript knows database is initialized (because of !)
    return this.database.findById(id);
  }
}

const service = new UserService();
service.init(); // Must call this first!
service.getUser("1"); // OK
```

#### Best Practices

- Only use `!` when you have absolute certainty the value exists
- Prefer optional chaining (`?`.) when the value might legitimately be null/undefined
- Add comments explaining why you're using `!`.
- Consider refactoring to avoid needing `!` in the first place.

### The `any` type vs the `unknow` type (and why we avoid `any`)

Both `any` and `unknown` can hold any value, but they behave very differently in terms of type safety. Understanding this difference is crucial for writing maintainable TypeScript code.


#### The `any` Type: The Escape Hatch 

`any` completely disables type checking for that value. It's like telling TypeScript: "Turn off your brain, I'll handle this myself."


#### Why any is Dangerous 

```typescript
// Problem 1: No autocomplete
let user: any = getUser();
user. // TypeScript offers NO suggestions

// Problem 2: Errors propagate silently
function processUser(user: any) {
  // This might fail at runtime, but TypeScript won't warn you
  return user.profile.settings.theme;
}

// Problem 3: It infects other types
interface ApiResponse {
  data: any; // Now everyone who uses this loses type safety
}

// Problem 4: Refactoring becomes impossible
// If you change the shape of user data, TypeScript won't catch breaking changes
```

#### The `unknown` Type: The Safe Alternative

`unknown` is like `any` in that it can hold any value, but it's type-safe. You cannot perform operations on an `unknown` value until you narrow its type.


```typescript
let data: unknown = "hello";

data = 123;           // OK
data = { foo: "bar" }; // OK
data = [1, 2, 3];     // OK

// TypeScript PREVENTS operations on 'unknown'
// console.log(data.toUpperCase()); // ERROR: Object is of type 'unknown'
// console.log(data.foo);           // ERROR: Object is of type 'unknown'
// data();                          // ERROR: Object is of type 'unknown'

// You MUST narrow the type first
if (typeof data === "string") {
  console.log(data.toUpperCase()); // OK: TypeScript knows it's a string
}

if (Array.isArray(data)) {
  console.log(data.length); // OK: TypeScript knows it's an array
}
```

#### Type Guards with `unknown`

```typescript
// Custom type guard function
function isUser(value: unknown): value is User {
  return (
    typeof value === "object" &&
    value !== null &&
    "id" in value &&
    "name" in value &&
    "email" in value
  );
}

function processUnknownData(data: unknown) {
  if (isUser(data)) {
    // TypeScript knows data is User here
    console.log(data.name);
    console.log(data.email);
  } else {
    console.log("Not a valid user");
  }
}
```
## Error Handling in TypeScript

Error handling is critical for building robust applications. TypeScript provides excellent tools to catch, handle, and communicate errors safely.

### Basic try/catch/finally


The `try/catch/finally` statement is the foundation of error handling in TypeScript. It allows you to attempt risky operations and gracefully handle failures.

### Basic Structure

```typescript
try {
  // Code that might throw an error
  const result = riskyOperation();
  console.log(result);
} catch (error) {
  // Code that runs if an error occurs
  console.error("Something went wrong:", error);
} finally {
  // Code that ALWAYS runs, whether there was an error or not
  // Great for cleanup: closing files, releasing resources, etc.
  console.log("Cleaning up...");
}
```

### Throwing Errors

Use the `throw` keyword to create and throw errors. You can throw any value, but it's best practice to throw `Error` objects or custom error classes.


### Basic Throwing

```typescript
function divide(a: number, b: number): number {
  if (b === 0) {
    throw new Error("Cannot divide by zero");
  }
  return a / b;
}

try {
  const result = divide(10, 0);
} catch (error) {
  console.error(error.message); // "Cannot divide by zero"
}
```

### Throwing Different Types

```typescript
// Good: Throw Error objects
throw new Error("Something went wrong");

// Good: Throw custom error classes (see below)
throw new ValidationError("Invalid email format");

// Bad: Throw strings or primitives (loses stack trace)
throw "Something went wrong"; // Don't do this
throw 404; // Don't do this
```

### Understanding the `error` Type in catch Blocks



In TypeScript 4.4+, the `error` parameter in catch blocks is typed as `unknown` by default (not `any`). This is safer but requires you to check the type before using it.


### Handling Unknown Errors
```typescript
try {
  riskyOperation();
} catch (error) {
  // error is of type 'unknown'

  // Option 1: Check if it's an Error instance
  if (error instanceof Error) {
    console.error(error.message);
    console.error(error.stack);
  }

  // Option 2: Type guard
  if (isError(error)) {
    console.error(error.message);
  }

  // Option 3: Type assertion (if you're certain)
  const err = error as Error;
  console.error(err.message);

  // Option 4: Just log it (safest)
  console.error("An error occurred:", error);
}

// Helper type guard
function isError(error: unknown): error is Error {
  return error instanceof Error;
}
```

### Custom Error Classes

Custom error classes let you create specific error types for different failure scenarios. This makes error handling more precise and maintainable.


### Creating Custom Errors

```typescript
// Base custom error
class AppError extends Error {
  constructor(
    message: string,
    public code: string,
    public statusCode: number = 500
  ) {
    super(message);
    this.name = "AppError";

    // Maintains proper stack trace (TypeScript specific)
    Object.setPrototypeOf(this, AppError.prototype);
  }
}

// Specific error types
class ValidationError extends AppError {
  constructor(
    message: string,
    public field?: string
  ) {
    super(message, "VALIDATION_ERROR", 400);
    this.name = "ValidationError";
    Object.setPrototypeOf(this, ValidationError.prototype);
  }
}

class NotFoundError extends AppError {
  constructor(resource: string, id: string) {
    super(`${resource} with id ${id} not found`, "NOT_FOUND", 404);
    this.name = "NotFoundError";
    Object.setPrototypeOf(this, NotFoundError.prototype);
  }
}

class AuthenticationError extends AppError {
  constructor(message: string = "Authentication failed") {
    super(message, "AUTH_ERROR", 401);
    this.name = "AuthenticationError";
    Object.setPrototypeOf(this, AuthenticationError.prototype);
  }
}

class AuthorizationError extends AppError {
  constructor(message: string = "Insufficient permissions") {
    super(message, "AUTHORIZATION_ERROR", 403);
    this.name = "AuthorizationError";
    Object.setPrototypeOf(this, AuthorizationError.prototype);
  }
}
```
