-- Empty stage test script for THlib.

Include('THlib.lua')


stage.group.New('Test', 'init', {lifeleft=2,power=100,faith=30000,bomb=3}, false, 1)

stage.group.AddStage('Test', '1@Test', {lifeleft=8,power=400,faith=30000,bomb=8}, false)
stage.group.DefStageFunc('1@Test', "init", function(self)
    _init_item(self)
    difficulty=self.group.difficulty
    New(mask_fader,'open')
    New(_G[lstg.var.player_name])
    New(temple_background)
    LoadMusicRecord('spellcard')

    task.New(self, function()
        PlayMusic('spellcard', 0.5, 0)

        task.Wait(3600) -- wait 1 minute
        stage.group.FinishGroup()
    end)
end)


