let log = (data: any) => {
  console.log(data);
};

// 1. String Literal Types
// Instead of just 'string', it MUST be exactly one of these three words.
type Theme = "light" | "dark" | "system";

function getTheme(): Theme {
  let thems: Theme[] = ["light"];

  return thems[0];
}
let currentTheme: Theme = getTheme(); // OK

log(currentTheme);
