package net.fabricmc.stunning.mixin;

import net.fabricmc.stunning.Stunning;
import net.minecraft.enchantment.EnchantmentHelper;
import net.minecraft.entity.player.PlayerEntity;
import net.minecraft.item.ItemStack;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(PlayerEntity.class)
public class PlayerEntityMixin {
    @Inject(method = "disableShield", at = @At("HEAD"), cancellable = true)
    private void disableShield(boolean sprinting, CallbackInfo ci) {
        PlayerEntity player = (PlayerEntity) (Object) this;
        ItemStack mainHandStack = player.getMainHandStack();
        if (EnchantmentHelper.getLevel(Stunning.STUNNING, mainHandStack) > 0) {
            ci.cancel();
        }
    }
}
