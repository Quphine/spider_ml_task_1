void main(){
    print('hello world');
    for (int i = 0; i <= 5; i++){
        print('uhmmm, I\'m back guys! ${i+1}');
    }

    
    String num = 'hi';
    int num1 = 123;
    dynamic hi = 1.20043;
    print(num1.isEven);
    print('${num} ${num1} ${hi}');
    print(greeting());
    print(greeting2());
    List integer_arr = [1,2,3];
    print(integer_arr);
    for (int i in integer_arr){
        print(i);
    }
    integer_arr.indexOf(123);
    integer_arr.add('String');
    int i = 0;
    while (i<5) {
      print(123);
      i++;
    }

    User user1 = User('Prasanna');
    user1.login();

}

String greeting(){
    return 'Hello';
}

String greeting2() => 'hello';

class User{
  String username;

  User(this.username);
  
  void login(){
    print('Logged in!');
  }

}

class SuperUser extends User{

  SuperUser(super.username);

  void publish(){
    print('published!');
  }
}