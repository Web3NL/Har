import { writable, get } from 'svelte/store'
import { actor } from './auth'

export const dashboard = writable(
    await get(actor).userDashboard().then(
        res => {
            if (res['ok']) {
                return res['ok']
            } else {
                console.error(res)
            }
        }           
    )
)

export async function updateDashboard() {
    await get(actor).userDashboard().then(
        res => {
            if (res['ok']) {
                dashboard.update( () => res['ok'] )
            } else {
                console.error(res)
            }
        }           
    )
}