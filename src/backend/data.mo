import Types "types";
import Har "har";

module {

    public func globalStats(usertime: Types.Usertime) : Types.GlobalStats {
        let users = usertime.size();
        var totalTime = 0;
        for (time in usertime.vals()) {
            totalTime += time;
        };
        {users; totalTime}
    };

    public func userDashboard(
        p: Principal, 
        usertime: Types.Usertime, 
        userdata: Types.Userdata, 
        harhistories: Types.HarHistories,
        ) : Types.UserDashboardResult {
        switch (usertime.get(p)) {
            case null #err(#UnknownPrincipal);
            case (?totalTime) {
                let dashboard = do ? {
                    let user = userdata.get(p)!;
                    let username = user.username;
                    let status = user.status;
                    let created = user.created;
                    let principal = p;
                    let activity = Har.calcActivity(p, harhistories);

                    let dashboard: Types.UserDashboard = {
                        totalTime;
                        username;
                        created;
                        status;
                        principal;
                        activity;
                    };

                    dashboard
                };

                switch (dashboard) {
                    case null {assert false; #err(#UnknownError);};
                    case (?dashboard) (#ok(dashboard))
                };
            };
        };
    };
       
}