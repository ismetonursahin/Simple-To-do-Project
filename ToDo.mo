// import ettik
import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Text "mo:base/Text";

//actor -> canister -> akıllı sözleşme

actor Assistant {
  //class
  type ToDo = {
    description : Text;
    completed : Bool;
  };

  // fonksiyon -> query
  // update -> yeni bilgi girişi

  func natHash(n : Nat) : Hash.Hash {
    Text.hash(Nat.toText(n));
  };

  //değişkenler -> let -> immutable
  // -> var -> mutable

  var todos = Map.HashMap<Nat, ToDo>(0, Nat.equal, natHash);
  var nextId : Nat = 0;

  public query func getTodos() : async [ToDo] {
    Iter.toArray(todos.vals());
  };

  //bilgi ekleme

  public func addToDo(description : Text) : async Nat {
    let id = nextId;
    todos.put(id, { description = description; completed = false });
    nextId += 1;
    id;
  };

  public func completeTodo(id : Nat) : async () {
    ignore do ? {
      let description = todos.get(id)!.description;
      todos.put(id, { description; completed = true });

    };
  };

  public query func showTodos() : async Text {
    var output : Text = "\n______TO-DOs_____";
    for (todo : ToDo in todos.vals()) {
      output #= "\n" # todo.description;
      if (todo.completed) { output #= " +" };

    };

    output # "\n";
  };

  public func clearCompleted() : async () {
    todos := Map.mapFilter<Nat, ToDo, ToDo>(
      todos,
      Nat.equal,
      natHash,
      func(_, todo) { if (todo.completed) null else ?todo },
    );
  };

};
