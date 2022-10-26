import Time "mo:base/Time";
import Result"mo:base/Result";
import List "mo:base/List";
import HM "mo:base/HashMap";

module {

    // GENERAL
    public type Time = Time.Time;

    // USER DATA
    public type Username = Text;
    
    public type User = {
        var username: Username;
        var status: Text;
        var created: Time;
    };

    public type Usertime = HM.HashMap<Principal,Nat>;
    public type Userdata = HM.HashMap<Principal,User>;
    
    public type UserDashboardResult = Result.Result<UserDashboard,UserDashboardError>;
    
    public type UserDashboard = {
        principal: Principal;
        username: Text;
        totalTime: Nat;
        activity: Float;
        status: Text;
        created: Time;
    };
    
    public type UserDashboardError = {#UnknownPrincipal; #UnknownError};
    
    public type GlobalStats = {
        users: Nat;
        totalTime: Nat;
    };
    
    // USER REGISTRATION
    public type NewUserResult = Result.Result<Username,NewUserError>;

    public type NewUserError = {#PrincipalAlreadyExists; #UsernameAlreadyExists; #UsernameNotAllowed;};
    
    // HAR
    public type HarDuration = Time;

    public type HarHistory = List.List<Time>;

    public type HarId = (Principal, Text);

    public type HarHistories = HM.HashMap<HarId, HarHistory>;

    public type HarEvent = {
        name: Text;
        duration: HarDuration;
        targetPromile: Nat; 
    };

    public type HarEvents = [HarEvent];

    public type HarStatus = {
        name: Text;
        done: Bool;
        time: Time;
    };
  
    public type HarCheck = [HarStatus];

    public type CheckHarError = {#NoHarHistory;};

    public type CheckHarResult = Result.Result<HarCheck,CheckHarError>;

    public type StartHarResult = Result.Result<Time,StartHarError>;

    public type StartHarError = {#HarNotDone: Time; #UnknownPrincipal; #UnknownHarIndex; #OtherError};

    public type HarScore = {
        maxClicksPerDay: Int; // DAY_NANOS / event duration
        weight: Int; // maxClicksPerDay / BASE_DURATION
        targetScore: Int; // maxDayScore * targetPromile / 1000
    };

    public type HarScores = [HarScore];

    // ADMIN
    public type AdminUser = {
        username : Username;
        status : Text;
        created : Time;
    };

    // TESTING
    public type TestResult = Result.Result<(),Text>;
    
}