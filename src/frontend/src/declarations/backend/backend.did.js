export const idlFactory = ({ IDL }) => {
  const TestResult = IDL.Variant({ 'ok' : IDL.Null, 'err' : IDL.Text });
  const Time = IDL.Int;
  const HarStatus = IDL.Record({
    'done' : IDL.Bool,
    'name' : IDL.Text,
    'time' : Time,
  });
  const HarCheck = IDL.Vec(HarStatus);
  const CheckHarError = IDL.Variant({ 'NoHarHistory' : IDL.Null });
  const CheckHarResult = IDL.Variant({
    'ok' : HarCheck,
    'err' : CheckHarError,
  });
  const Username = IDL.Text;
  const GlobalStats = IDL.Record({ 'totalTime' : IDL.Nat, 'users' : IDL.Nat });
  const AdminUser = IDL.Record({
    'status' : IDL.Text,
    'created' : Time,
    'username' : Username,
  });
  const NewUserError = IDL.Variant({
    'UsernameAlreadyExists' : IDL.Null,
    'PrincipalAlreadyExists' : IDL.Null,
    'UsernameNotAllowed' : IDL.Null,
  });
  const NewUserResult = IDL.Variant({ 'ok' : Username, 'err' : NewUserError });
  const StartHarError = IDL.Variant({
    'UnknownHarIndex' : IDL.Null,
    'OtherError' : IDL.Null,
    'UnknownPrincipal' : IDL.Null,
    'HarNotDone' : Time,
  });
  const StartHarResult = IDL.Variant({ 'ok' : Time, 'err' : StartHarError });
  const UserDashboard = IDL.Record({
    'status' : IDL.Text,
    'created' : Time,
    'principal' : IDL.Principal,
    'username' : IDL.Text,
    'totalTime' : IDL.Nat,
    'activity' : IDL.Float64,
  });
  const UserDashboardError = IDL.Variant({
    'UnknownPrincipal' : IDL.Null,
    'UnknownError' : IDL.Null,
  });
  const UserDashboardResult = IDL.Variant({
    'ok' : UserDashboard,
    'err' : UserDashboardError,
  });
  return IDL.Service({
    '_testDataStoreLengths' : IDL.Func([], [TestResult], ['query']),
    '_testNewUser' : IDL.Func([], [TestResult], ['query']),
    'checkHars' : IDL.Func([], [CheckHarResult], ['query']),
    'checkUsername' : IDL.Func([Username], [IDL.Text], ['query']),
    'globalStats' : IDL.Func([], [GlobalStats], ['query']),
    'isRegistered' : IDL.Func([], [IDL.Bool], ['query']),
    'listUsers' : IDL.Func([], [IDL.Vec(AdminUser)], ['query']),
    'newUser' : IDL.Func([Username], [NewUserResult], []),
    'startHar' : IDL.Func([IDL.Nat], [StartHarResult], []),
    'userDashboard' : IDL.Func([], [UserDashboardResult], ['query']),
  });
};
export const init = ({ IDL }) => { return []; };
