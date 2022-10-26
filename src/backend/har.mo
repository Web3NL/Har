import Hash "mo:base/Hash";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Time "mo:base/Time";
import List "mo:base/List";
import Int "mo:base/Int";
import HM "mo:base/HashMap";
import Buffer "mo:base/Buffer";
import Float "mo:base/Float";
import Debug "mo:base/Debug";

import Types "types";

module {
    func getHarEvents() : Types.HarEvents {
        [
            {name = "nano";       duration = 5    * 60 * 10**9 / 100;   targetPromile = 125   },
            {name = "micro";      duration = 10   * 60 * 10**9 / 100;   targetPromile = 250   },
            {name = "milli";      duration = 20   * 60 * 10**9 / 100;   targetPromile = 250   },
            {name = "normal";     duration = 45   * 60 * 10**9 / 100;   targetPromile = 250   },
            {name = "kilo";       duration = 90   * 60 * 10**9 / 100;   targetPromile = 500   },
            {name = "mega";       duration = 180  * 60 * 10**9 / 100;   targetPromile = 500   },
            {name = "giga";       duration = 360  * 60 * 10**9 / 100;   targetPromile = 750   },
            {name = "terra";      duration = 720  * 60 * 10**9 / 100;   targetPromile = 1000  },
            {name = "humongous";  duration = 1440 * 60 * 10**9 / 100;   targetPromile = 1000  },
        ]
    };

    public func compareHarId(x : Types.HarId, y: Types.HarId) : Bool {
        Principal.equal(x.0, y.0) and Text.equal(x.1, y.1)
    };

    public func hashHarId(x : Types.HarId) : Hash.Hash {
        Text.hash(Principal.toText(x.0) # x.1)
    };

    func checkHarDone(lastHarTime: Types.Time, duration: Types.HarDuration, now: Types.Time) : Bool {
        (lastHarTime + duration) < now
    };

    public func checkHars(
        p: Principal,
        harhistories: Types.HarHistories,
        ) : Types.CheckHarResult {
        let now = Time.now();
        let harEvents: Types.HarEvents = getHarEvents();
        let harCheckBuffer = Buffer.Buffer<Types.HarStatus>(0);
        for (har in harEvents.vals()) {
        let harId = (p, har.name);
        switch (harhistories.get(harId)) {
            case null {
            harCheckBuffer.add({
                name = har.name;
                done = true;
                time = har.duration;
            });
            };
            case (?history) {
            switch (List.get(history, 0)) {
                case null assert false;
                case (?time) {
                switch (checkHarDone(time, har.duration, now)) {
                    case true {
                    harCheckBuffer.add({
                        name = har.name;
                        done = true;
                        time = har.duration;
                    });
                    };
                    case false {
                    harCheckBuffer.add({
                        name = har.name;
                        done = false;
                        time = (time + har.duration) - now;
                    });
                    };
                };
                }; 
            };
            };
        };
        };
        let harCheck = harCheckBuffer.toArray();
        #ok(harCheck)
    };

    public func startHar(
        p: Principal, 
        harIndex: Nat,
        usertime: Types.Usertime,
        harhistories: Types.HarHistories,
        ) : Types.StartHarResult {
        let now = Time.now();
        let harEvents: Types.HarEvents = getHarEvents();
        if (harIndex > harEvents.size()) return #err(#UnknownHarIndex);
        let harName = harEvents[harIndex].name;
        let harId = (p, harName);
        let duration = harEvents[harIndex].duration;
        switch (harhistories.get(harId)) {
        case null {
            let history = List.make<Types.Time>(now);
            harhistories.put(harId,history);
            switch (usertime.get(p)) {
            case null return #err(#UnknownPrincipal);
            case (?totalTime) {
                let newTotalTime = totalTime + Int.abs(duration);
                usertime.put(p,newTotalTime);
            };
            };
            #ok(duration)
        };
        case (?history) {
            switch (List.get(history, 0)) {
            case null #err(#OtherError);
            case (?lastHarTime) {
                switch (checkHarDone(lastHarTime, duration, now)) {
                case true {
                    let newHistory = List.push(now, history);
                    harhistories.put(harId,newHistory);
                    switch (usertime.get(p)) {
                    case null return #err(#UnknownPrincipal);
                    case (?totalTime) {
                        let newTotalTime = totalTime + Int.abs(duration);
                        usertime.put(p,newTotalTime);
                    };
                    };
                    #ok(duration)
                };
                case false {
                    let timeLeft = (lastHarTime + duration) - now;
                    #err(#HarNotDone(timeLeft))
                };
                };
            };
            };
        };
        };
    };

    func calcHarScores(): [Types.HarScore] {
        let harEvents: Types.HarEvents = getHarEvents();
        let size = harEvents.size();
        let BASE_DURATION = harEvents[0].duration;
        let DAY_NANOS = (24 * 60 * 60 * 10**9) / 100;

        let harScore: Types.HarScore = {
        maxClicksPerDay = 0;
        weight = 0;
        targetScore = 0;
        };

        var harScoreArray: [var Types.HarScore] = Array.init(size, harScore);

        var i = 0;
        for (harEvent in harEvents.vals()) {
        let maxClicksPerDay = DAY_NANOS / harEvent.duration;
        let weight = harEvent.duration / BASE_DURATION;
        let targetScore = (maxClicksPerDay * weight) * harEvent.targetPromile / 1000;

        let score: Types.HarScore = {
            maxClicksPerDay;
            weight;
            targetScore;
        };

        harScoreArray[i] := score;
        i += 1;
        };

        Array.freeze(harScoreArray)
    };

    func calcTotalTargetScore(harScores: Types.HarScores): Int {
        var total: Int = 0;
        for (score in harScores.vals()) {
            total += score.targetScore
        };
        total
    };

    public func calcActivity(p: Principal, harhistories: Types.HarHistories): Float {
        let harEvents: Types.HarEvents = getHarEvents();
        let harScores: Types.HarScores = calcHarScores();
        let totalTargetScore: Float = Float.fromInt(calcTotalTargetScore(harScores));
        var activity: Float = 0;
        var i = 0;
        for (event in harEvents.vals()) {
            let harId = (p, event.name);
            switch (harhistories.get(harId)) {
                case null {};
                case (?history) {
                    let DAY_NANOS = (24 * 60 * 60 * 10**9) / 100;
                    let t = Time.now() - DAY_NANOS;
                    let maxClicksPerDay = harScores[i].maxClicksPerDay;
                    var list = List.take<Types.Time>(history, Int.abs(maxClicksPerDay)); 
                    list := List.filter(
                        list,
                        func(har: Types.Time): Bool {har > t}
                    );
                    let score = List.size(list) * harScores[i].weight;
                    activity += Float.fromInt(score);
                    i += 1;
                };
            };
        };
        activity / totalTargetScore * 100
    };
}