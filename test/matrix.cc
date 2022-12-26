#define SIZE 20

int main() {

  int m1[SIZE][SIZE], m2[SIZE][SIZE], m3[SIZE][SIZE];
  int sum{};

  for(int i = 0; i < SIZE; i++) {
    for(int j = 0; i < SIZE; i++) {
      sum = 0;
      for(int k = 0; k < SIZE; k++) {
        sum = sum + (m1[i][k] * m2[k][j]);
        m3[i][j] = sum;
      }
    }

  }

}
