import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";

import Error "mo:base/Error";
import Types "types";

module {

    let II = "cldk2-ipnjo-kh4fv-4s5qs-eldea-ankym-nq3i5-cvhns-psbmz-zhlh5-6ae";
    let XPS0 = "ur5fy-nwhjd-etlkm-fklqh-2erkf-ujkzk-ntnii-hfvq5-emxzm-sydgy-jae";

    public func listUsers(p: Principal, userdata: Types.Userdata) : [Types.AdminUser] {
        // if (not isAdmin(p)) throw Error.reject("UNALLOWED PRINICPAL");
        let buf = Buffer.Buffer<Types.AdminUser>(0);
        for (user in userdata.vals()) {
        let adminUser = {
            username = user.username;
            status = user.status;
            created = user.created;
        };
        buf.add(adminUser)
        };
        buf.toArray()
    };

    func isAdmin(p: Principal) : Bool {
        Principal.toText(p) == II or Principal.toText(p) == XPS0
    };

}