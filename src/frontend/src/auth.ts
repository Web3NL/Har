import { writable } from 'svelte/store'
import { AuthClient } from '@dfinity/auth-client'

import { backend, createActor, canisterId } from '../../declarations/backend'
import { identityProvider } from './identityProvider'

enum AuthStatus {
  Welcome,
  Anon,
  NewUser,
  Play,
}

export let authStatus = writable(AuthStatus.Welcome)
export let actor = writable(backend)

const client = await AuthClient.create()

await updateAuthStatus()

async function updateAuthStatus() {
  const authed = await client.isAuthenticated()

  switch (authed) {

    case true:
      const identity = client.getIdentity()
      
      if (canisterId) {
        const localActor = createActor(
          canisterId, 
          {agentOptions:{identity}}
        )
        const registered = await localActor.isRegistered()
        
        switch (registered) {
          case true:
            actor.update(() => localActor)
            authStatus.update(() => AuthStatus.Play)
            break
          case false:
            actor.update(() => localActor)
            authStatus.update(() => AuthStatus.NewUser)
        }
      }
      break 

    case false:
      sessionStorage.getItem("Anon") ? 
        authStatus.update(() => AuthStatus.Anon) :
          authStatus.update(() => AuthStatus.Welcome)

      actor.update(() => backend)
  }
}

export function playAnon() {
  sessionStorage.setItem("Anon","true")
  authStatus.update(() => AuthStatus.Anon)
}

export function login() {
    client.login({
      identityProvider,
      onSuccess: updateAuthStatus,
    });
  }

export async function logout() {
  await client.logout()
  sessionStorage.removeItem("Anon")
  await updateAuthStatus()
};