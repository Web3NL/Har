<script lang="ts">
import { updateDashboard } from '../dashboard'
import { actor } from '../auth'

export let name = "HAR"
export let time: bigint
export let done: boolean

export let timeToggle: boolean
export let index: number

type T = bigint | string

function readableTime(t:bigint) {
    let h: T, m: T, s: T = BigInt(0) 
    t = t / BigInt(10**9);
    
    t>3600n ? h = t / 3600n : h = 0n;
    t % 3600n > 60n ? m = t % 3600n / 60n : m = 0n;
    s = (t % 3600n % 60n);

    h < 10n ? h = "0" + h.toString() : h = h.toString();
    m < 10n ? m = "0" + m.toString() : m = m.toString();
    s < 10n ? s = "0" + s.toString() : s = s.toString();  
    return  h + ":" + m + ":" + s;
}

async function countDown() {
    if (!done && time>0) {
        time -= BigInt(10**9)
    } else if (!done && time <= BigInt(0)) {
        done = true
        await checkHar()
    }
}

async function checkHar() {
    const harCheck = await $actor.checkHars()
    if (harCheck['ok']) {
        name = harCheck['ok'][index].name
        time = harCheck['ok'][index].time
        done = harCheck['ok'][index].done
    } else {
        console.error(harCheck)
    }
}

async function startHar() {
    done = false
    let res = await $actor.startHar(BigInt(index))
    if (res['ok']) {
        done = false
        time = res['ok']
    } else if (res['err']['HarNotDone']) {
        done = false
        time = res['err']['HarNotDone']
    } else {
        console.error(res)
    }
    await updateDashboard()
}

$: t = timeToggle ? countDown() : countDown()
$: text = done ? "" : readableTime(time)

</script>

{#if done}
    <div on:click={startHar}
        class="p-6 max-w-xs rounded-lg bg-green-800 border-2 border-green-700 hover:bg-green-700 mx-auto mb-3 cursor-pointer">
        <p class="mb-2 text-2xl font-bold tracking-tight">{name}</p>
        <p class="font-normal text-green-400">{text}</p>
    </div>
{:else}
    <div
        class="p-6 max-w-xs rounded-lg bg-gray-700 mx-auto mb-3">
        <p class="mb-2 text-2xl font-bold tracking-tight">{name}</p>
        <p class="font-normal text-gray-400">{text}</p>
    </div>
{/if}
