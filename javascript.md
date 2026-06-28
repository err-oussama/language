# JavaScript Core Syntax Reference


## Variables

**Variable Declaration**

```javascript
const PI = 3.14;      // Block-scoped, cannot be reassigned
let count = 0;        // Block-scoped, can be reassigned
var legacy = "old";   // Function-scoped (Avoid in modern JS)
```



## Data Types

```javascript
// Primitive Data Types
const str = "Hello";            // String (or 'Hello' or `Hello`)
const num = 42;                 // Number (Integers and Floats)
const bool = true;              // Boolean
const big = 9007199254740991n;  // BigInt (Arbitrary precision)
const id = Symbol();            // Symbol (Unique identifier)
const empty = null;             // Null (Intentional absence)
let undef;                      // Undefined

// Template Literals (String Interpolation)
const name = "World";
const greeting = `Hello, ${name}!`; 
```

## Operators

### Arithmetic & Assignment

```javascript
let a = 10 + 2;  // +, -, *, /, %, ** (exponent)
a += 5;          // a = a + 5 (Also -=, *=, /=, %=, **=)
a++; a--;        // Increment / Decrement
```

### Comparison

```javascript
5 === "5"  // false (Strict equality: checks type and value)
5 == "5"   // true  (Loose equality: type coercion)
5 !== 5    // false
5 > 3      // true
```

### Logical

```javascript
true && false  // AND
true || false  // OR
!true          // NOT
```

### Modern Nullish & Optional Operators

```javascript
const val = null ?? "default"; // Nullish Coalescing (returns "default")
const len = obj?.prop?.length; // Optional Chaining (prevents errors if null/undefined)
```

### Ternary Operator

```javascript
const status = age >= 18 ? "Adult" : "Minor";
```




## Control Flow & Loops

### Conditionals


```javascript
if (x > 0) { /* ... */ } 
else if (x === 0) { /* ... */ } 
else { /* ... */ }

switch (color) {
  case "red": break;
  case "blue": break;
  default: break;
}
```

### Loops
```javascript
for (let i = 0; i < 5; i++) { }       // Standard loop
while (true) { break; }               // While loop
do { } while (false);                 // Do-While loop

for (let item of array) { }           // Iterates over VALUES (Arrays, Strings)
for (let key in object) { }           // Iterates over KEYS (Objects)

// Labels & Break/Continue (Rarely used)
outerLoop: for (let i = 0; i < 5; i++) {
  if (i === 2) continue; // Skips to next iteration
  if (i === 4) break outerLoop; // Breaks specific labeled loop
}
```


## Functions

### Function Declaration (Hoisted)

```javascript
function add(a, b) { return a + b; }
```

### Function Expression

```javascript
const subtract = function(a, b) { return a - b; };
```

### Arrow Function (ES6)

```javascript
const multiply = (a, b) => a * b;
const square = x => x * x; // Implicit return if no braces
const greet = () => console.log("Hi");
```

### Default Parameters & Rest Arguments

```javascript
function createUser(name, role = "user", ...hobbies) {
  // hobbies is an array of all extra arguments passed
}
```

### Immediately Invoked Function Expression (IIFE)

```javascript
(function() { console.log("Runs immediately"); })();
```

### Generators (Can be paused and resumed)

```javascript
function* idMaker() {
  let index = 0;
  while (true) yield index++;
}
const gen = idMaker();
gen.next().value; // 0
```

## Objects & Arrays

### Object Literal

```javascript
const user = {
  name: "Alice",
  age: 30,
  "key with spaces": true, // Bracket notation required for access
  greet() { return `Hi, I'm ${this.name}`; } // Method shorthand
};
```

### Array Literal

```javascript
const arr = [1, 2, 3];
```

###  Destructuring (Unpacking)

```javascript
const { name, age } = user;         // Object destructuring
const [first, ...rest] = arr;       // Array destructuring (first=1, rest=[2,3])
```

### Spread Operator (Copying/Merging)

```javascript
const newUser = { ...user, age: 31 };       // Shallow clone object
const newArr = [...arr, 4, 5];              // Clone/extend array
```

### Computed Property Names

```javascript
const prop = "score";
const obj = { [prop]: 100 }; // { score: 100 }
```




## Classes & Object-Oriented Programming

```javascript
class Animal {
  // Static property/method
  static kingdom = "Animalia";
  static create(name) { return new Animal(name); }

  constructor(name) {
    this.name = name; // Instance property
  }

  // Getter & Setter
  get info() { return this.name; }
  set info(val) { this.name = val.toUpperCase(); }

  // Instance method
  speak() { console.log(`${this.name} makes a noise.`); }
}

class Dog extends Animal {
  constructor(name, breed) {
    super(name); // Call parent constructor
    this.breed = breed;
  }
  
  speak() { console.log(`${this.name} barks.`); } // Override
}

const dog = new Dog("Rex", "Lab");
dog.speak();
```



## Error Handling


```javascript
try {
  // Code that may throw an error
  if (Math.random() > 0.5) throw new Error("Something went wrong!");
  if (Math.random() > 0.5) throw "A custom string error";
} catch (error) {
  // Handle the error
  console.error(error.message);
} finally {
  // Runs regardless of success or failure (e.g., cleanup)
  console.log("Cleanup complete.");
}
```

## Asynchronous JavaScript

```javascript
// Callbacks (Legacy)
setTimeout(() => console.log("Delayed"), 1000);

// Promises
const myPromise = new Promise((resolve, reject) => {
  const success = true;
  success ? resolve("Done!") : reject("Failed!");
});

myPromise
  .then(result => console.log(result))
  .catch(error => console.error(error))
  .finally(() => console.log("Always runs"));

// Async / Await (Modern Standard)
async function fetchData() {
  try {
    const response = await fetch("https://api.example.com/data");
    const data = await response.json();
    return data;
  } catch (error) {
    console.error("Network error:", error);
  }
}
```



## Modules (ES6)


```javascript
// --- file: math.js ---
export const PI = 3.14;
export function add(a, b) { return a + b; }
export default class Calculator { /* ... */ }

// --- file: app.js ---
import Calculator, { PI, add } from './math.js';
import * as MathUtils from './math.js'; // Import everything as an object
```


## Regular Expressions

```javascript
const regex = /hello/i;                     // Literal syntax (i = case-insensitive)
const regex2 = new RegExp("hello", "g");    // Constructor (g = global)

const str = "Hello world";
regex.test(str);            // true (Checks for match)
str.match(/o/g);            // ['o', 'o'] (Returns matches)
str.replace(/world/, "JS"); // "Hello JS"
```


## Miscellaneous / Rare Syntax

```javascript
debugger; // Pauses execution if DevTools are open

// Labels (Used with break/continue in nested loops)
myLabel: for (let i = 0; i < 5; i++) {
  break myLabel; 
}

// The `with` statement (Deprecated / Strict Mode Forbidden)
// with (obj) { name = "Bob"; } 

// Comma Operator (Evaluates multiple expressions, returns last)
let x = (1, 2, 3); // x is 3
```







