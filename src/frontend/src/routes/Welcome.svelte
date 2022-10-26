<script lang="ts">
import { login, playAnon} from '../auth'
import GlobalStats from '../components/GlobalStats.svelte'
import Menu from '../components/Menu.svelte'
import Button from '../components/Button.svelte'
</script>

<Menu />

<Button label="Login with II" on:click={login}  />

<Button label="Play as Anon" on:click={playAnon} />

<GlobalStats />

<div class="absolute bottom-5 left-0 right-0">
    <a class="static block w-52 mx-auto" href="https://internetcomputer.org/">
        <img alt="Internet Computer" src="ic.svg" />
    </a>
</div>

