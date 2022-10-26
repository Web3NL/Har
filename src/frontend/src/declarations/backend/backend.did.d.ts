import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface AdminUser {
  'status' : string,
  'created' : Time,
  'username' : Username,
}
export type CheckHarError = { 'NoHarHistory' : null };
export type CheckHarResult = { 'ok' : HarCheck } |
  { 'err' : CheckHarError };
export interface GlobalStats { 'totalTime' : bigint, 'users' : bigint }
export type HarCheck = Array<HarStatus>;
export interface HarStatus { 'done' : boolean, 'name' : string, 'time' : Time }
export type NewUserError = { 'UsernameAlreadyExists' : null } |
  { 'PrincipalAlreadyExists' : null } |
  { 'UsernameNotAllowed' : null };
export type NewUserResult = { 'ok' : Username } |
  { 'err' : NewUserError };
export type StartHarError = { 'UnknownHarIndex' : null } |
  { 'OtherError' : null } |
  { 'UnknownPrincipal' : null } |
  { 'HarNotDone' : Time };
export type StartHarResult = { 'ok' : Time } |
  { 'err' : StartHarError };
export type TestResult = { 'ok' : null } |
  { 'err' : string };
export type Time = bigint;
export interface UserDashboard {
  'status' : string,
  'created' : Time,
  'principal' : Principal,
  'username' : string,
  'totalTime' : bigint,
  'activity' : number,
}
export type UserDashboardError = { 'UnknownPrincipal' : null } |
  { 'UnknownError' : null };
export type UserDashboardResult = { 'ok' : UserDashboard } |
  { 'err' : UserDashboardError };
export type Username = string;
export interface _SERVICE {
  '_testDataStoreLengths' : ActorMethod<[], TestResult>,
  '_testNewUser' : ActorMethod<[], TestResult>,
  'checkHars' : ActorMethod<[], CheckHarResult>,
  'checkUsername' : ActorMethod<[Username], string>,
  'globalStats' : ActorMethod<[], GlobalStats>,
  'isRegistered' : ActorMethod<[], boolean>,
  'listUsers' : ActorMethod<[], Array<AdminUser>>,
  'newUser' : ActorMethod<[Username], NewUserResult>,
  'startHar' : ActorMethod<[bigint], StartHarResult>,
  'userDashboard' : ActorMethod<[], UserDashboardResult>,
}
