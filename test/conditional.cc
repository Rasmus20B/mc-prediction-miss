#include <iostream> 

int main() {
  int num;
  std::cin >> num;

  if(num == 5) {
    num = 1;
  } else if(num == 9) {
    num = 10;
  } else if(num == 1) {
    num = 7;
  } else {
    num = 0;
  }

  return num;
}
