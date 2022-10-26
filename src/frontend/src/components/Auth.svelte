<script lang="ts">
    import { auth, login } from '../auth'
</script>

<div class="text-center mx-auto my-5">
    <button class="rounded-sm bg-gray-600 py-2 px-16"
    on:click={login}>Login with II</button>
</div>
<div class="text-center mx-auto my-5">
    <button class="rounded-sm bg-gray-600 py-2 px-16"
    on:click={()=>$auth.loggedIn=true}>Play as Anon</button>
</div>