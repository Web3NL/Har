import HM         "mo:base/HashMap";
import Int        "mo:base/Int";
import Iter       "mo:base/Iter";
import List       "mo:base/List";
import Principal  "mo:base/Principal";
import Result     "mo:base/Result";
import Time       "mo:base/Time";
import Char       "mo:base/Char";
import Text       "mo:base/Text";
import Buffer     "mo:base/Buffer";
import Array      "mo:base/Array";
import Option     "mo:base/Option";

import Types "types";
import Admin "admin";
import Registration "registration";
import Har "har";
import Data "data";

actor {

  // CONSTANTS
  private let ANON_USER = "2vxsx-fae";

  // INIT STABLE VARS
  private stable var usertimeEntries : [(Principal, Nat)] = [];
  private stable var userdataEntries : [(Principal, Types.User)] = [];
  private stable var harhistoriesEntries : [(Types.HarId, Types.HarHistory)] = [];

  // INIT DATA VARS
  private let usertime = HM.fromIter<Principal, Nat>( usertimeEntries.vals(), 2, Principal.equal, Principal.hash );
  private let userdata = HM.fromIter<Principal, Types.User>( userdataEntries.vals(), 2, Principal.equal, Principal.hash );
  private let harhistories: Types.HarHistories = HM.fromIter<Types.HarId, Types.HarHistory>( harhistoriesEntries.vals(), 2, Har.compareHarId, Har.hashHarId );
  
  // USER REGISTRATION
  public shared query ({caller}) func isRegistered() : async Bool {
    Registration.isRegistered(caller, usertime)
  }; 

  public query func checkUsername(username : Types.Username) : async Text {
	Registration.checkUsername(username, userdata)
  };

  public shared (msg) func newUser(username: Types.Username) : async Types.NewUserResult {
    Registration.newUser(msg.caller, username, "", usertime, userdata)
  };

  // INIT ANON USER
  do {
    let p = Principal.fromText(ANON_USER);
    switch (userdata.get(p)) {
      case (?user) {
        assert(user.username == "Anon")
      };
      case null {
        ignore {
          Registration.newUser(p, "Anon", "Is watching...",usertime,userdata);
        };
      };
    };
  };

  // USER DATA
  public query func globalStats() : async Types.GlobalStats {
	  Data.globalStats(usertime)
  };

  public shared query ({caller}) func userDashboard() : async Types.UserDashboardResult {
	  Data.userDashboard(caller, usertime, userdata, harhistories)
  };

  // HAR
  public shared query ({caller}) func checkHars() : async Types.CheckHarResult {
    Har.checkHars(caller, harhistories)
  };

  public shared ({caller}) func startHar(harIndex: Nat) : async Types.StartHarResult {
    Har.startHar(caller, harIndex, usertime, harhistories)
  };

  // CANISTER UPGRADE
  system func preupgrade() {
    usertimeEntries       := Iter.toArray(usertime.entries());
    userdataEntries       := Iter.toArray(userdata.entries());
    harhistoriesEntries   := Iter.toArray(harhistories.entries());
  };

  system func postupgrade() {
    usertimeEntries     := [];
    userdataEntries     := [];
    harhistoriesEntries := [];
  };

  // TESTING
  public query func _testDataStoreLengths() : async Types.TestResult {
    let dataStoreLengths = [
      usertime.size(),
      userdata.size(),
    ];

    let n = dataStoreLengths[0];
    for (i in dataStoreLengths.vals()) {
      if (i!=n) {return #err("unequal data store lengths")};
    };
    #ok()
  };

  public query func _testNewUser() : async Types.TestResult {
    let p = Principal.fromText(ANON_USER);
    if (Registration.newUser(p,"","",usertime,userdata) != #err(#PrincipalAlreadyExists)) return #err("principal check error");

    let x = Principal.fromText("aaaaa-aa"); 
    if (Registration.newUser(x,"Anon","",usertime,userdata) != #err(#UsernameAlreadyExists)) return #err("username check error 1");
    if (Registration.newUser(x,"0anon","",usertime,userdata) != #err(#UsernameNotAllowed)) return #err("username check error 2");
    if (Registration.newUser(x,"_anon","",usertime,userdata) != #err(#UsernameNotAllowed)) return #err("username check error 3");
    if (Registration.newUser(x,"abc","",usertime,userdata) != #err(#UsernameNotAllowed)) return #err("username check error 4");
    if (Registration.newUser(x,"a123456789a123456789a","",usertime,userdata) != #err(#UsernameNotAllowed)) return #err("username check error 5");
    if (Registration.newUser(x,"/-^*","",usertime,userdata) != #err(#UsernameNotAllowed)) return #err("username check error 6");
    if (Registration.newUser(x,"Peter-Man","",usertime,userdata) != #err(#UsernameNotAllowed)) return #err("username check error 7");

    #ok
  };

  // ADMIN
  public shared query ({caller}) func listUsers() : async [Types.AdminUser] {
    Admin.listUsers(caller, userdata)
  };

};

  