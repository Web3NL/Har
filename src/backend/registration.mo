import Time "mo:base/Time";
import Char "mo:base/Char";
import Types "types";

module {
    
    func checkPrincipal(p : Principal, usertime: Types.Usertime) : ?Principal {
        switch (usertime.get(p)) {
        case (?user) return ?p;
        case null return null;
        };
    };

    func usernameExists(username : Types.Username, userdata: Types.Userdata) : Bool {
        for (user in userdata.vals()) {
        if (user.username == username) (return true)
        };
        return false
    };

    func validateUsername(username : Types.Username) : Bool {
        if (username.size() < 4 or username.size() > 20) return false;
        var firstChar = true;
        for (c in username.chars()) {
        if (not Char.isAlphabetic(c) and not Char.isDigit(c)) return false;
        if (firstChar and not Char.isAlphabetic(c)) return false;
        if (firstChar and Char.isAlphabetic(c)) firstChar := false; 
        };
        true
    };

    public func checkUsername(username : Types.Username, userdata: Types.Userdata) : Text {
        switch (validateUsername(username)) {
            case true {
                switch (usernameExists(username, userdata)) {
                    case true return "Username not available";
                    case false "Username is available!"
                };
            };
            case false return "Username not allowed";
        };
    };

    public func newUser(
        p: Principal, 
        username: Types.Username, 
        status: Text,
        usertime: Types.Usertime,
        userdata: Types.Userdata,
        ) : Types.NewUserResult {
        switch (checkPrincipal(p, usertime)) {
            case (?p) return #err(#PrincipalAlreadyExists);
            case null {
                switch (usernameExists(username, userdata)) {
                    case true return #err(#UsernameAlreadyExists);
                    case false {
                        if (not validateUsername(username)) return #err(#UsernameNotAllowed);
                        let now = Time.now();
                        let user: Types.User = {
                        var username  = username;
                        var status    = status;
                        var created   = now;
                        };
                        usertime.put(p,0);
                        userdata.put(p,user);
                        return #ok(username)
                    };
                };
            };
        };
    };

    public func isRegistered(p: Principal, usertime: Types.Usertime) : Bool {
        switch (usertime.get(p)) {
            case null return false;
            case _ return true;
        }
    }; 

}