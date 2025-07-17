package net.fabricmc.stunning;

import net.fabricmc.api.ModInitializer;
import net.minecraft.enchantment.Enchantment;
import net.minecraft.registry.Registries;
import net.minecraft.registry.Registry;
import net.minecraft.util.Identifier;

public class Stunning implements ModInitializer {
    public static final Enchantment STUNNING = new StunningEnchantment();

    @Override
    public void onInitialize() {
        Registry.register(Registries.ENCHANTMENT, new Identifier("stunning", "stunning"), STUNNING);
    }
}
