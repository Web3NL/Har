<script lang="ts">
import { onMount } from 'svelte'

import { actor } from '../auth'
import HarButton from './HarButton.svelte'

onMount(async() => {
    await checkHars()

    interval = setInterval(()=>{
        timeToggle = !timeToggle
    },
    1000
    )

    return () => clearInterval(interval)
})

let buttons = []
let timeToggle = true
let interval: ReturnType<typeof setInterval>

const checkHars = async () => {
    const harCheck = await $actor.checkHars()
    if (harCheck['ok']) {
        buttons = harCheck['ok']
    } else {
        console.error(harCheck)
    }
}
</script>

{#each buttons as button, i}
    <HarButton 
        name={button.name}
        done={button.done}
        time={button.time}

        timeToggle={timeToggle}
        index={i}
    />
{/each}
