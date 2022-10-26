<script lang="ts">
import { actor, logout, authStatus } from '../auth'
import Button from './Button.svelte'

let username: string
let warning = ""
let disabled = true
let placeholder = "JohnDoe"

async function register() {
    warning = "Logging in..."
    const register = await $actor.newUser(username)
    register['ok'] ? $authStatus = 3 : $authStatus = 0
}

const keyUp = async () => {
    const check = await $actor.checkUsername(username)
    let message = check.toString()
    if (message === "Username is available!") {
        disabled = false
        title = greenTitle
        input = greenInput
        text = greenText
        warning = "Username is available!"
    } else if (username.length === 0) {
        disabled = true
        title = grayTitle
        input = grayInput
        text = grayText
        warning = ""
    } else if (message === "Username not allowed") {
        disabled = true
        title = redTitle
        input = redInput
        text = redText
        warning = "Only letters and numbers, 4-20 characters"
    } 
}

let redInput = `bg-red-50 border border-red-500 text-red-900 placeholder-red-700 
        text-sm rounded-lg focus:ring-red-500 focus:border-red-500 block w-full 
        p-2.5 dark:bg-red-100 dark:border-red-400`

let greenInput = `bg-green-50 border border-green-500 text-green-900 placeholder-green-700 
        text-sm rounded-lg focus:ring-green-500 focus:border-green-500 block w-full 
        p-2.5 dark:bg-green-100 dark:border-green-400`

let grayInput = `bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg 
        focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 
        dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 
        dark:focus:border-blue-500`

let redTitle = `block mb-2 text-sm font-medium text-red-700 dark:text-red-500`
let greenTitle = `block mb-2 text-sm font-medium text-green-700 dark:text-green-500`
let grayTitle = `block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300`

let redText = `mt-2 text-sm text-red-600 dark:text-red-500`
let greenText = `mt-2 text-sm text-green-600 dark:text-green-500`
let grayText = `mt-2 text-sm text-gray-600 dark:text-gray-500`

let title = grayTitle
let text = grayText
let input = grayInput

</script>


<div class="w-72 mx-auto">


<h1 class="mb-2 mt-4 text-3xl font-extrabold text-gray-900 dark:text-white md:text-5xl lg:text-6xl"><span class="text-transparent bg-clip-text bg-gradient-to-r to-emerald-600 from-sky-400">Join the club</span><br>Earn some Har</h1>
<p class="mb-12 text-lg font-normal text-gray-500 lg:text-xl dark:text-gray-400">Learn more</p>
    
    <div class="mb-6">
        <label for="username-success" class={title}>Choose a username</label>
        <input type="text" id="username-success" bind:value={username} on:keyup={keyUp}
        class={input} placeholder={placeholder}>
        <p class={text}>{warning}</p>
    </div>

</div>

<Button on:click={register} label="Register" disabled={disabled} />
<Button label="Logout" on:click={logout} />



